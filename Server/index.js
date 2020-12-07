const express = require('express');
const app = express();
const cors = require('cors');
// const pool = require('./db');
const processing = require('./processing');
const queryBank = require('./queryBank');

// middleware
app.use(cors());
app.use(express.json());      //req.body

//ROUTES

// //get all todo
// app.get('/todos', async(req, res)=>{
//     try{
//         const allTodos = await pool.query(`SELECT * FROM todo`);
//         res.json(allTodos.rows);
//     } catch(err){
//         console.log(err.message);
//     }
// });

app.get('/city', async(req, res)=>{
    try {
        const code = req.query.airport_code;
        const city = await queryBank.cities('one',code);
        res.json(city);
    } catch(err) {
        console.log(err.message);
    }
});

app.get('/cities', async(req, res)=>{
    try {
        const allCities = await queryBank.cities('all');
        res.json(allCities);
    }
    catch(err) {
        console.log(err.message);
    }
});

app.get('/findFlights', async(req, res)=>{
    try{
        const args = [req.query.from, req.query.to, req.query.date.toString(), req.query.travelers];
        const directFlights = await queryBank.directFlights('all', {from: args[0], to: args[1], date: args[2]});

        const oneStopFlights = await queryBank.connectionFlights('all', {from: args[0], to: args[1], date: args[2]});

        const allFlights = [directFlights, oneStopFlights];

        allFlights.forEach(function(type) {
            type.forEach(function(flight) {
                processing.calculateDuration(flight);
                processing.calculateFarePrice(flight);
            });
        });
        res.json(allFlights);
    }
    catch(err){
        console.log(err.message);
    }
});

app.get('/getFlight', async(req, res)=> {
    try
    {
        const flight = await processing.getFlight(req.query.id, req.query.id2);
        res.json(flight);
    }
    catch(err){
        console.log(err.message);
    }
});

app.get('/priceDiff', async(req, res)=> {
    try {
        var priceDiff = await processing.priceDiff(req.query.oldFlight, req.query.newFlight);
        res.json(priceDiff);
    } catch(err) {
        console.log(err.message);
    }
})

app.get('/booking', async(req, res)=> {
    try {
        let flight = await queryBank.getBooking(req.query.bookRef, req.query.type);
        res.json(flight);

    } catch(err) {
        console.log(err.message);
    }
})

app.post('/purchase', async(req, res)=>{
    try
    {
        const flight = await processing.getFlight(req.body.flight.flight, req.body.flight.flight2);

        const passengerInfo = req.body.passengerInfo;
        const contactInfo = req.body.contactInfo;
        const paymentInfo = req.body.paymentInfo;

        var price;
        var priceWithTax;
        var amount;
        var fare;
        var indirect = (flight.conn1_id !== undefined);

        switch(req.body.flight.fare)
        {
            case 'Economy':
                price = flight.econPrice;
                priceWithTax = flight.econWithTax;
                fare = "economy";
                break;
            case 'Economy Plus':
                price = flight.econPlusPrice;
                priceWithTax = flight.econPlusWithTax;
                fare = "economy_plus";
                break;
            case 'Business':
                price = flight.businessPrice;
                priceWithTax = flight.businessWithTax;
                fare = "business";
                break;
        }
        //Check availability of flight(s)
        var available = await queryBank.checkAvailability(fare, flight.id, req.body.flight.travelers);
        if(indirect)
            available = await queryBank.checkAvailability(fare, flight.conn1_id, req.body.flight.travelers);

        if(available)
        {
            while (true) {
                try {
                    var bookRef = processing.generateBookRef(6);

                    amount = (priceWithTax*req.body.flight.travelers).toFixed(2);
                    //Start transaction query
                    await queryBank.transactionStatus("start");

                    // //Update seat on flight.id, if indirect then update flight.conn1_id
                    // await queryBank.postSeat(fare, flight.id, req.body.flight.travelers);
                    // if (indirect)
                    //     await queryBank.postSeat(fare, flight.conn1_id, req.body.flight.travelers);

                    //If credit card is not already on file, put it in database
                    await queryBank.postCreditCard(paymentInfo.cardNum, paymentInfo.nameOnCard,
                                                                    paymentInfo.expMonth, paymentInfo.expYear);

                    //Insert transaction into database and return transaction ID
                    await queryBank.postBooking(bookRef, paymentInfo.cardNum, null, amount, contactInfo.email, contactInfo.phone);

                    //If travelers not already on file, put in database and return passenger ID
                    //For each traveler, create ticket for flight(s)
                    for (var i=0; i<req.body.flight.travelers; i++)
                    {
                        var passID = await queryBank.postPassenger(passengerInfo[i].first_name, passengerInfo[i].last_name, passengerInfo[i].date_of_birth);
                        var ticket;
                        if (indirect)
                            ticket = await queryBank.postTicket(bookRef, flight.conn1_id, passID, req.body.flight.fare);

                        await queryBank.postTicket(bookRef, flight.id, passID, req.body.flight.fare, ticket);


                    }
                    await queryBank.transactionStatus("commit");
                    break;
                } catch(err) {
                    await queryBank.transactionStatus("rollback");
                    console.log(err.message);
                }
            }
            //TODO Update flight availabilities, booking
            res.status(200).json({
                bookRef: bookRef,
                travelers: passengerInfo,
                payment:
                    {cardLastFour: paymentInfo.cardNum.toString().substr(12),
                        amount: amount}
                });
        }
        else
            res.sendStatus(403);

    } catch(err) {
        console.log(err.message);
    }
});

app.put('/purchase', async(req, res)=> {
    try {
        const booking = await  queryBank.getBooking(req.body.bookRef, 'all');
        const oldFlight = await processing.getFlight(req.body.oldFlight.flight, req.body.oldFlight.flight2);
        const newFlight = await processing.getFlight(req.body.newFlight.flight, req.body.newFlight.flight2);
        const priceDiff = await processing.priceDiff(req.body.oldFlight, req.body.newFlight);
        var indirect = (oldFlight.conn1_id !== undefined);
        var newIndirect = (newFlight.conn1_id !== undefined);
        var newFare;
        while(true) {
            try {

                //Start transaction query
                await queryBank.transactionStatus("start");
                //Change amount of booking

                await queryBank.putBookingAmount(req.body.bookRef,
                    parseFloat(booking.amount) + parseFloat(priceDiff.priceDiff));

                //For each passenger, update tickets
                for (var i = 0; i < booking.travelers.length; i++) {
                    var tickets = await queryBank.getAllTickets(req.body.bookRef, booking.travelers[i].id);
                    //CASE 1: Both are indirect
                    if (indirect && newIndirect) {
                        await queryBank.updateTicket(tickets[0].id, newFlight.id, req.body.newFlight.fare);
                        await queryBank.updateTicket(tickets[1].id, newFlight.conn1_id, req.body.newFlight.fare);
                    } else if (!indirect && newIndirect) {
                        //CASE 2: Old is direct, new is indirect
                        var ticketID = await queryBank.updateTicket(tickets[0].id, newFlight.conn1_id, req.body.newFlight.fare);
                        await queryBank.postTicket(req.body.bookRef, newFlight.id, booking.travelers[i].id, req.body.newFlight.fare, ticketID);
                    } else if (indirect && !newIndirect) {
                        //CASE 3: Old is indirect, new is direct
                        await queryBank.updateTicket(tickets[1].id, newFlight.id, req.body.newFlight.fare);
                        await queryBank.deleteTicket(tickets[0].id);
                    } else {
                        //CASE 4: Both are direct
                        await queryBank.updateTicket(tickets[0].id, newFlight.id, req.body.newFlight.fare);
                    }
                }

                await queryBank.transactionStatus("commit");
                break;
            } catch(err) {
                await queryBank.transactionStatus("rollback");
                console.log(err.message);
            }
        }
        const newBooking = await queryBank.getBooking(req.body.bookRef, 'all');
        res.status(200).json({
            travelers: newBooking.travelers,
            payment:
                {cardLastFour: newBooking.cardLastFour,
                    amount: newBooking.amount}
        });
    } catch(err) {
        console.log(err.message);
    }
})

// //insert a todo
// app.post('/todos', async(req, res)=>{
//     try{
//
//         const {description} = req.body;
//         const newTodo = await pool.query(`INSERT INTO todo (description) VALUES($1) RETURNING *`,
//             [description]);
//
//         res.json(newTodo);
//
//     } catch(err){
//         console.log(err.message);
//     }
// });
//
// //update a todo by id
// app.put("/todos/:id", async (req, res) => {
//     try {
//         const { id } = req.params;
//         const { description } = req.body;
//         const updateTodo = await pool.query(`UPDATE todo SET description = $1
//                                          WHERE todo_id = $2`,
//             [description, id]);
//         res.json("Todo was updated!");
//     } catch (err) {
//         console.error(err.message);
//     }
// });
//
// //delete a todo by id
// app.delete("/todos/:id", async (req, res) => {
//     try {
//         const { id } = req.params;
//         const deleteTodo = await pool.query(`DELETE FROM todo
//                                          WHERE todo_id = $1`,
//             [id]);
//         res.json("Todo was deleted!");
//     } catch (err) {
//         console.log(err.message);
//     }
// });

// set up the server listening at port 5000 (the port number can be changed)
app.listen(5000, ()=>{
    console.log("Server has started on port 5000");
});