
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
        if(flights.length === 0) {
            noFlights();
            return;
        }
        showFlights();
    }
    catch (err) {
        console.log(err.message);
    }
}
function convertTime(departTime) {
    var hour = departTime.getHours();
    var min = departTime.getMinutes();
    var AmOrPm = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if(hour===0)
        hour = 12;
    return hour.toString() + ":" + min.toString() + AmOrPm;
}

function insertInfo(row, data) {
    //Flight Number
    var flightNum = row.insertCell();
    flightNum.innerHTML = data.flight_id.toString();
    //Depart time
    var departing = row.insertCell();
    var departTime = new Date(data.scheduled_departure);
    departing.innerHTML = convertTime(departTime);
    console.log(departing);
    //Arrive time
    var arriving = row.insertCell();
    var arriveTime  = new Date(data.scheduled_arrival);
    arriving.innerHTML = convertTime(arriveTime);
    //Stops. For now, just insert nonstop TODO implement layovers
    var stops = row.insertCell();
    stops.innerHTML = "Nonstop";
    //Flight time
    var res = Math.abs(arriveTime - departTime) / 1000;
    var hoursBetween = Math.floor(res / 3600) % 24;
    var minutesBetween = Math.floor(res / 60) % 60;
    var flightLength = row.insertCell();
    flightLength.innerHTML = hoursBetween.toString()+"h "+minutesBetween+"m";
    //Fare pricing, for now hardcode values, maybe calculate later TODO determine fare prices
    var economy = row.insertCell();
    economy.setAttribute("id", "ecoCol");
    economy.innerHTML = "$200";
    var economyPlus = row.insertCell();
    economyPlus.setAttribute("id","ecoPlusCol");
    economyPlus.innerHTML = "$500";
    var business = row.insertCell();
    business.setAttribute("id","businessCol");
    business.innerHTML = "$800";


}

function noFlights() {
    console.log("No flights");
}

function showFlights() {
    document.getElementById("depart").innerHTML = from;
    document.getElementById("arrive").innerHTML = to;
    document.getElementById("departCity").innerHTML = flights[0].depart_city.trim();
    document.getElementById("arriveCity").innerHTML = flights[0].arrive_city.trim();
    var table = document.getElementById("flightsTable").getElementsByTagName('tbody')[0];
    for(i=0; i < flights.length; i++)
    {
        var row = table.insertRow();
        insertInfo(row, flights[i]);
    }
}