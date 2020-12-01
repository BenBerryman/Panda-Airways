const express = require('express');
const app = express();
const cors = require('cors');
const pool = require('./db');
const calculations = require('./calculations');

// middleware
app.use(cors());
app.use(express.json());      //req.body

//ROUTES

//get all todo
app.get('/todos', async(req, res)=>{
    try{
        const allTodos = await pool.query(`SELECT * FROM todo`);
        res.json(allTodos.rows);
    } catch(err){
        console.log(err.message);
    }
});

app.get('/city', async(req, res)=>{
    try {
        const code = req.query.airport_code;
        const city = await pool.query('SELECT city FROM airport WHERE airport_code LIKE $1',
            [code]);
        res.json(city.rows[0].city);
    } catch(err) {
        console.log(err.message);
    }
});

app.get('/cities', async(req, res)=>{
    try {
        const allCities = await pool.query('SELECT DISTINCT city, airport_code FROM airport');
        res.json(allCities.rows);
    }
    catch(err) {
        console.log(err.message);
    }
});

app.get('/findFlights', async(req, res)=>{
    try{
        const args = [req.query.from, req.query.to, req.query.date.toString(), req.query.travelers];

        const directFlights = await pool.query(`${calculations.directFlights()}
                                            WHERE departing.airport_code LIKE $1 AND arriving.airport_code LIKE $2
                                            AND scheduled_departure::text LIKE $3`,
            [args[0],args[1],args[2]+' %']);

        const oneStopFlights = await pool.query(`${calculations.connectionFlights()}
                                            WHERE connection1Departing.scheduled_departure > departing.scheduled_arrival
                                             AND departing.airport_code LIKE $1 AND arriving.airport_code LIKE $2
                                              AND departing.scheduled_departure::text LIKE $3
                                               AND connection1Departing.scheduled_departure::text LIKE $3;`,
            [args[0],args[1],args[2]+' %']);

        const allFlights = [directFlights.rows, oneStopFlights.rows];

        allFlights.forEach(function(type) {
            type.forEach(function(flight) {
                calculations.calculateDuration(flight);
                calculations.calculateFarePrice(flight);
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
            flight = await pool.query(`${calculations.directFlights()}
                                            WHERE departing.id=$1;`, [flightID]);
        else
            flight = await pool.query(`${calculations.connectionFlights()}
                                            WHERE departing.id=$1 AND connection1Departing.id=$2;`, [flightID, flightID2]);

        calculations.calculateDuration(flight.rows[0]);
        calculations.calculateFarePrice(flight.rows[0]);
        res.json(flight.rows);

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
        if(flight.fare === "Economy")
            price = flight.flight.econPrice;
        else if(flight.fare === "Economy Plus")
            price = flight.flight.econPlusPrice;
        else
            price = flight.flight.businessPrice;
        amount = (price*flight.travelers).toFixed(2);

        var indirect = false;
        if (flight.flight.conn1_id != undefined)
            indirect = true;

        var postCard = await pool.query(
            `INSERT INTO credit_card VALUES ($1, $2, $3, $4);`, 
            [paymentInfo.cardNum, paymentInfo.nameOnCard, paymentInfo.expMonth, paymentInfo.expYear]);
        
        var postTrans = await pool.query(
            `INSERT INTO transaction (card_number, voucher, amount, contact_email, contact_phone_number, transaction_date)
            VALUES ($1, $2, $3, $4, $5, CURRENT_TIMESTAMP) RETURNING id;`, 
            [paymentInfo.cardNum, "NULL", amount, contactInfo.email, contactInfo.phone]);
        
        var i;
        for (i=0; i<flight.travelers; i++){
            var postPass = await pool.query(
                `INSERT INTO passenger (first_name, last_name, dob)
                VALUES ($1, $2, $3) RETURNING id;`, 
                [passengerInfo[i].firstName, passengerInfo[i].lastName, passengerInfo[i].dob]);

            var postTicket = await pool.query(
                `INSERT INTO ticket (transaction_id, flight_id, standby_flight_id, passenger_id, fare_condition)
                VALUES ($1, $2, $3, $4, $5);`, 
                [postTrans.rows[0].id, flight.flight.id, 0, postPass.rows[0].id, flight.fare]);

            if (indirect)
                var postConnTicket = await pool.query(
                    `INSERT INTO ticket (transaction_id, flight_id, standby_flight_id, passenger_id, fare_condition)
                    VALUES ($1, $2, $3, $4, $5);`, 
                    [postTrans.rows[0].id, flight.flight.conn1_id, 0, postPass.rows[0].id, flight.fare]);
        }

        const response = {
            status: "success"
        }

        res.json(response);
    } catch(err) {
        console.log(err.message);
    }

});

//insert a todo
app.post('/todos', async(req, res)=>{
    try{

        const {description} = req.body;
        const newTodo = await pool.query(`INSERT INTO todo (description) VALUES($1) RETURNING *`,
            [description]);

        res.json(newTodo);

    } catch(err){
        console.log(err.message);
    }
});

//update a todo by id
app.put("/todos/:id", async (req, res) => {
    try {
        const { id } = req.params;
        const { description } = req.body;
        const updateTodo = await pool.query(`UPDATE todo SET description = $1
                                         WHERE todo_id = $2`,
            [description, id]);
        res.json("Todo was updated!");
    } catch (err) {
        console.error(err.message);
    }
});

//delete a todo by id
app.delete("/todos/:id", async (req, res) => {
    try {
        const { id } = req.params;
        const deleteTodo = await pool.query(`DELETE FROM todo
                                         WHERE todo_id = $1`,
            [id]);
        res.json("Todo was deleted!");
    } catch (err) {
        console.log(err.message);
    }
});

// set up the server listening at port 5000 (the port number can be changed)
app.listen(5000, ()=>{
    console.log("Server has started on port 5000");
});