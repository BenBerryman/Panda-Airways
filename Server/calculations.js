

const calculateFarePrice = (flight) => {
    const economyStarter = 200;
    const economyPlusStarter = 500;
    const businessStarter = 800;
    const currentDate = new Date();
    var timeTillFlight = new Date(flight.scheduled_departure)-currentDate;
    timeTillFlight = Math.pow(timeTillFlight/2000000,2);
    const flightTime = calculateDuration(flight);
    //Formulas to calculate price
    var econPrice = (economyStarter/(Math.log(flightTime)/18))+(100000/timeTillFlight);
    var econPlusPrice = (economyPlusStarter/(Math.log(flightTime)/18))+(100000/timeTillFlight);
    var businessPrice = (businessStarter/(Math.log(flightTime)/18))+(100000/timeTillFlight);

    //Add tax and round to 2 decimals
    econPrice = +(econPrice+(0.0825*econPrice)).toFixed(2);
    econPlusPrice = +(econPlusPrice+(0.0825*econPlusPrice)).toFixed(2);
    businessPrice = +(businessPrice+(0.0825*businessPrice)).toFixed(2);
    flight.econPrice = econPrice;
    flight.econPlusPrice = econPlusPrice;
    flight.businessPrice = businessPrice;
};

const calculateDuration = (flight) => {
    var departTime = new Date(flight.scheduled_departure);
    var arriveTime  = new Date(flight.scheduled_arrival);
    var res = Math.abs(arriveTime - departTime) / 1000; //Time between depart and arrive in seconds
    var hoursBetween = Math.floor(res / 3600) % 24;
    var minutesBetween = Math.floor(res / 60) % 60;
    flight.duration = hoursBetween.toString()+"h "+minutesBetween+"m";
    return arriveTime-departTime;
}
const directFlights = () => {
    return `SELECT departing.flight_id, scheduled_departure, scheduled_arrival, departing.city AS depart_city,
       departing.airport_code AS depart, arriving.city AS arrive_city, arriving.airport_code AS arrive
            FROM
                (SELECT flight_id,scheduled_departure, scheduled_arrival, city, airport_code
                FROM flights JOIN airport
                ON flights.departure_airport=airport.airport_code) departing
            JOIN
                (SELECT flight_id, city, airport_code
                FROM flights JOIN airport
                ON flights.arrival_airport=airport.airport_code) arriving
            ON departing.flight_id=arriving.flight_id`;
}

const connectionFlights = ()  => {
    return `SELECT departing.flight_id, departing.scheduled_departure AS scheduled_departure,
                departing.scheduled_arrival AS initial_scheduled_arrival, departing.city AS depart_city,
                 departing.airport_code AS depart, connection1Departing.scheduled_departure
                  AS conn1_scheduled_departure, connection1Departing.scheduled_arrival
                   AS scheduled_arrival, connection1.city AS conn1_city, connection1.airport_code
                    AS conn1,connection1Departing.flight_id AS conn1_flight_id, arriving.city AS arrive_city,
                     arriving.airport_code AS arrive
            FROM
                (SELECT flight_id,scheduled_departure, scheduled_arrival, city, airport_code
                 FROM flights JOIN airport
                                   ON flights.departure_airport=airport.airport_code) departing
                    JOIN
                (SELECT flight_id, city, airport_code
                 FROM flights JOIN airport
                                   ON flights.arrival_airport=airport.airport_code) connection1
                ON departing.flight_id=connection1.flight_id
                    JOIN
                ((SELECT flight_id, scheduled_departure, scheduled_arrival, city, airport_code
                 FROM flights JOIN airport
                                   ON flights.departure_airport=airport.airport_code) connection1Departing
                    JOIN
                (SELECT flight_id, city, airport_code
                 FROM flights JOIN airport
                                   ON flights.arrival_airport=airport.airport_code) arriving
                ON connection1Departing.flight_id=arriving.flight_id)
                ON connection1.airport_code=connection1Departing.airport_code`;
}

module.exports = {calculateFarePrice, calculateDuration, directFlights, connectionFlights};

