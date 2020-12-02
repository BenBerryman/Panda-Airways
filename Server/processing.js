

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

const generateBookRef = (length) => {
    var chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    var result = '';
    for (var i = length; i > 0; --i) result += chars[Math.round(Math.random() * (chars.length - 1))];
    return result;
}

module.exports = {calculateFarePrice, calculateDuration, generateBookRef};

