
const queryBank = require('./queryBank');

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

    flight.econPrice = +(econPrice.toFixed(2));
    flight.econPlusPrice = +(econPlusPrice.toFixed(2));
    flight.businessPrice = +(businessPrice.toFixed(2));
    flight.econWithTax = +((econPrice+(0.0825*econPrice)).toFixed(2));
    flight.econPlusWithTax = +((econPlusPrice+(0.0825*econPlusPrice)).toFixed(2));
    flight.businessWithTax = +((businessPrice+(0.0825*businessPrice)).toFixed(2));
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

const getFlight = async(flightID, flightID2)=> {
    try {
        let flight;
        if(flightID2 === undefined)
            flight = await queryBank.directFlights('one', {flightID: flightID});
        else
            flight = await queryBank.connectionFlights('one', {flightID: flightID, flightID2: flightID2});
        calculateDuration(flight);
        calculateFarePrice(flight);
        return flight;
    }
    catch (err) {
        console.log(err.message);
    }
}

const priceDiff = async(oldFlight, newFlight)=> {
    const newFl = await getFlight(newFlight.flight, newFlight.flight2);

    var price;
    var priceWithTax;
    switch(newFlight.fare)
    {
        case 'Economy':
            price = newFl.econPrice;
            priceWithTax = newFl.econWithTax;
            break;
        case 'Economy Plus':
            price = newFl.econPlusPrice;
            priceWithTax = newFl.econPlusWithTax;
            break;
        case 'Business':
            price = newFl.businessPrice;
            priceWithTax = newFl.businessWithTax;
    }
    var priceDiff = (priceWithTax*newFlight.travelers-oldFlight.amount);
    var refund = false;
    if(priceDiff<0)
        refund = true;
    return {
        priceDiff: priceDiff.toFixed(2),
        refund: refund
    };
}

const generateBookRef = (length) => {
    var chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    var result = '';
    for (var i = length; i > 0; --i) result += chars[Math.round(Math.random() * (chars.length - 1))];
    return result;
}

module.exports = {calculateFarePrice, calculateDuration, generateBookRef, getFlight, priceDiff};

