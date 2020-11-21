const express = require('express');
const app = express();
const cors = require('cors');
const pool = require('./db');

// middleware
app.use(cors());
app.use(express.json());      //req.body

//ROUTES

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

//get all todo
app.get('/todos', async(req, res)=>{
    try{
        const allTodos = await pool.query(`SELECT * FROM todo`);
        res.json(allTodos.rows);
    } catch(err){
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
        const args = [req.query.from, req.query.to, req.query.dates.toString(), req.query.fare, req.query.travelers];

        const allFlights = await pool.query(`SELECT departing.flight_id, scheduled_departure, scheduled_arrival, departing.city AS depart_city, departing.airport_code AS depart, arriving.city AS arrive_city, arriving.airport_code AS arrive
                                            FROM
                                                (SELECT flight_id,scheduled_departure, scheduled_arrival, city, airport_code
                                                FROM flights JOIN airport
                                                ON flights.departure_airport=airport.airport_code) departing
                                            JOIN
                                                (SELECT flight_id, city, airport_code
                                                FROM flights JOIN airport
                                                ON flights.arrival_airport=airport.airport_code) arriving
                                            ON departing.flight_id=arriving.flight_id
                                            WHERE departing.airport_code LIKE $1 AND arriving.airport_code LIKE $2
                                            AND scheduled_departure::text LIKE $3`,
            [args[0],args[1],args[2]+' %']);
        res.json(allFlights.rows);
    }
    catch(err){
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