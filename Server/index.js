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
        const flightID = req.query.id;
        const flightID2 = req.query.id2;
        let flight;
        if(flightID2 === undefined)
            flight = await queryBank.directFlights('one', {flightID: flightID});
        else
            flight = await queryBank.connectionFlights('one', {flightID: flightID, flightID2: flightID2});

        processing.calculateDuration(flight);
        processing.calculateFarePrice(flight);
        res.json(flight);
    }
    catch(err){
        console.log(err.message);
    }
});

app.post('/purchase', async(req, res)=>{
    try
    {
        const flight = req.body.flight;
        const passengerInfo = req.body.passengerInfo;
        const contactInfo = req.body.contactInfo;
        const paymentInfo = req.body.paymentInfo;

        var price;
        var amount;
        var fare;
        var indirect = false;
        if (flight.flight.conn1_id !== undefined)
            indirect = true;

        if(flight.fare === "Economy"){
            price = flight.flight.econPrice;
            fare = "economy";
        }
        else if(flight.fare === "Economy Plus"){
            price = flight.flight.econPlusPrice;
            fare = "economy_plus";
        }
        else{
            price = flight.flight.businessPrice;
            fare = "business";
        }
        //Check availability of flight(s)
        var available = await queryBank.checkAvailability(fare, flight.flight.id);
        if(indirect)
            available = await queryBank.checkAvailability(fare, flight.flight.conn1_id);

        if(available)
        {
            console.log(flight.flight.id);
            while (true) {
                try {
                    amount = (price*flight.travelers).toFixed(2);
                    //Start transaction query
                    await queryBank.transactionStatus("start");

                    //Update seat on flight.id, if indirect then update flight.conn1_id
                    await queryBank.updateSeat(fare, flight.flight.id);
                    if (indirect)
                        await queryBank.updateSeat(fare, flight.flight.conn1_id);

                    //If credit card is not already on file, put it in database
                    await queryBank.postCreditCard(paymentInfo.cardNum, paymentInfo.nameOnCard,
                                                                    paymentInfo.expMonth, paymentInfo.expYear);

                    //Insert transaction into database and return transaction ID
                    var transID = await queryBank.postTransaction(paymentInfo.cardNum, null, amount, contactInfo.email, contactInfo.phone);

                    //If travelers not already on file, put in database and return passenger ID
                    //For each traveler, create ticket for flight(s)
                    for (var i=0; i<flight.travelers; i++)
                    {
                        var passID = await queryBank.postPassenger(passengerInfo[i].firstName, passengerInfo[i].lastName, passengerInfo[i].dob);

                        await queryBank.postTicket(transID, flight.flight.id, null, passID, flight.fare);

                        if (indirect)
                            await queryBank.postTicket(transID, flight.flight.conn1_id, null, passID, flight.fare);
                    }
                    await queryBank.transactionStatus("commit");
                    break;
                } catch(err) {
                    await queryBank.transactionStatus("rollback");
                    console.log(err.message);
                }
            }
            //TODO Update flight availabilities, booking
            var bookRef = processing.generateBookRef(6);
        }
        else
            res.sendStatus(403);

        res.status(200).json(
            {bookRef: bookRef,
                travelers: passengerInfo,
                payment:
                    {cardLastFour: paymentInfo.cardNum.toString().substr(12),
                    amount: amount}
                });
    } catch(err) {
        console.log(err.message);
    }

});

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