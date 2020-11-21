
const query = window.location.search;
const urlParams = new URLSearchParams(query);
var from = urlParams.get('from');
var to = urlParams.get('to');
var dates = urlParams.get('dates');
var fare = urlParams.get('fare');
var travelers = urlParams.get('travelers');
let flights = [];
findFlights();

async function findFlights() {
    try {
        const response = await fetch("http://localhost:5000/findFlights/?"+$.param({
            from: from,
            to: to,
            dates: dates,
            fare: fare,
            travelers: travelers
        }));
        let resp = await response.json();
        flights = resp;
    }
    catch (err) {
        console.log(err.message);
    }
}

$(document).ready(function() {

});