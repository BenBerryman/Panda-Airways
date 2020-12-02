const pool = require('./db');

//TYPE can be either 'all' or 'one'
//IF 'all', args={to:<>, from:<>, date:<>}
//IF 'one', args={flightID:<>}
const directFlights = async(type, args) => {
    try
    {
        var response;
        var base = `SELECT departing.id, scheduled_departure, scheduled_arrival, departing.city AS depart_city,
            departing.flight_status AS depart_flight_status, departing.airport_code AS depart,
            arriving.city AS arrive_city, arriving.airport_code AS arrive
        FROM
            (SELECT id,scheduled_departure, scheduled_arrival, city, airport_code, flight_status
            FROM flight JOIN airport
            ON flight.departure_airport=airport.airport_code) departing
        JOIN
            (SELECT id, city, airport_code
            FROM flight JOIN airport
            ON flight.arrival_airport=airport.airport_code) arriving
        ON departing.id=arriving.id`;

        switch(type)
        {
            case "all":
                response = await pool.query(
                    `${base}
            WHERE departing.airport_code LIKE $1 AND arriving.airport_code LIKE $2
            AND scheduled_departure::text LIKE $3`,
                    [args.from, args.to, args.date+' %']);
                return response.rows;
            case "one":
                response = await pool.query(
                    `${base}
            WHERE departing.id=$1;`, [args.flightID]);
                return response.rows[0];
        }
    } catch(err) {
        console.log(err.message);
    }
}

//TYPE can be either 'all' or 'one'
//IF 'all', args={to:<>, from:<>, date:<>}
//IF 'one', args={flightID:<>, flightID2:<>}
const connectionFlights = async(type, args)  => {
    try
    {
        var response;
        var base = `SELECT departing.id,
                departing.scheduled_departure AS scheduled_departure,
                departing.scheduled_arrival AS initial_scheduled_arrival,
                departing.city AS depart_city,
                departing.flight_status AS depart_flight_status,
                departing.airport_code AS depart,
                connection1Departing.scheduled_departure AS conn1_scheduled_departure,
                connection1Departing.scheduled_arrival AS scheduled_arrival, 
                connection1.city AS conn1_city,
                connection1.airport_code AS conn1,
                connection1Departing.flight_status AS conn1_flight_status,
                connection1Departing.id AS conn1_id,
                arriving.city AS arrive_city,
                arriving.airport_code AS arrive
        FROM
            (SELECT id,scheduled_departure, scheduled_arrival, city, airport_code, flight_status
             FROM flight JOIN airport
                               ON flight.departure_airport=airport.airport_code) departing
                JOIN
            (SELECT id, city, airport_code
             FROM flight JOIN airport
                               ON flight.arrival_airport=airport.airport_code) connection1
            ON departing.id=connection1.id
                JOIN
            ((SELECT id, scheduled_departure, scheduled_arrival, city, airport_code, flight_status
             FROM flight JOIN airport
                               ON flight.departure_airport=airport.airport_code) connection1Departing
                JOIN
            (SELECT id, city, airport_code
             FROM flight JOIN airport
                               ON flight.arrival_airport=airport.airport_code) arriving
            ON connection1Departing.id=arriving.id)
            ON connection1.airport_code=connection1Departing.airport_code`;

        switch(type)
        {
            case "all":
                response = await pool.query(
                    `${base}
            WHERE connection1Departing.scheduled_departure > departing.scheduled_arrival
            AND departing.airport_code LIKE $1 AND arriving.airport_code LIKE $2
            AND departing.scheduled_departure::text LIKE $3
            AND connection1Departing.scheduled_departure::text LIKE $3;`,
                    [args.from, args.to, args.date+' %']);
                return response.rows;
            case "one":
                response = await pool.query(
                    `${base}
            WHERE departing.id=$1
            AND connection1Departing.id=$2;`,
                    [args.flightID, args.flightID2]);
                return response.rows[0];
        }
    } catch(err) {
        console.log(err.message);
    }
}

const cities = async(type, code=null) => {
    try
    {
        var response;
        switch(type)
        {
            case 'all':
                response = await pool.query('SELECT DISTINCT city, airport_code FROM airport');
                return response.rows;
            case 'one':
                response = await pool.query('SELECT city FROM airport WHERE airport_code LIKE $1', [code]);
                return response.rows[0].city;
        }
    } catch(err) {
        console.log(err.message);
    }
}

const checkAvailability = async(fare, flightID) => {
    try
    {
        var response;
        switch(fare)
        {
            case "economy":
                response = await pool.query(
                    `SELECT
                    CASE WHEN economy_available<=0
                        THEN FALSE
                    ELSE TRUE
                    END
                FROM flight WHERE id=$1;`,
                    [flightID]);
                break;
            case "economy_plus":
                response = await pool.query(
                    `SELECT
                    CASE WHEN economy_plus_available<=0
                        THEN FALSE
                    ELSE TRUE
                    END
                FROM flight WHERE id=$1;`,
                    [flightID]);
                break;
            case "business":
                response = await pool.query(
                    `SELECT
                    CASE WHEN business_available<=0
                        THEN FALSE
                    ELSE TRUE
                    END
                FROM flight WHERE id=$1;`,
                    [flightID]);
        }
        return response.rows[0].case;
    }
    catch(err)
    {
        console.log(err.message);
    }

}

const postCreditCard = async(cardNum, nameOnCard, expMonth, expYear) => {
    try
    {
        await pool.query(
            `INSERT INTO credit_card VALUES ($1, $2, $3, $4) ON CONFLICT(card_number) DO NOTHING`,
            [cardNum, nameOnCard, expMonth, expYear]);
    }
    catch(err)
    {
        console.log(err.message);
    }
}
const postTransaction = async(cardNum, voucher, amount, contactEmail, contactPhone) => {
    try
    {
        const response = await pool.query(
            `INSERT INTO transaction (card_number, voucher, amount, contact_email, contact_phone_number, transaction_date)
            VALUES ($1, $2, $3, $4, $5, CURRENT_TIMESTAMP) RETURNING id;`,
            [cardNum, null, amount, contactEmail, contactPhone]);
        return response.rows[0].id;
    } catch(err) {
        console.log(err.message);
    }
}
const postPassenger = async(firstName, lastName, dob) => {
    try
    {
        const response = await pool.query(
            `INSERT INTO passenger (first_name, last_name, dob)
                VALUES ($1, $2, $3) RETURNING id;`,
            [firstName, lastName, dob]);
        return response.rows[0].id;
    } catch(err) {
        console.log(err.message);
    }
}
const postTicket = async(transactionID, flightID, standbyFlightID, passID, fare) => {
    try
    {
        const response = await pool.query(
            `INSERT INTO ticket (transaction_id, flight_id, standby_flight_id, passenger_id, fare_condition)
                VALUES ($1, $2, $3, $4, $5);`,
            [transactionID, flightID, null, passID, fare]);
    } catch(err) {
        console.log(err.message);
    }
}

module.exports = {directFlights, connectionFlights, cities, checkAvailability,
    postCreditCard, postTransaction, postPassenger, postTicket};