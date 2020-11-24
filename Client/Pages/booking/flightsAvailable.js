
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
function convertTime(time) {
    var hour = time.getHours();
    var min = time.getMinutes();
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
    var linkEcon = document.createElement("a");
    linkEcon.href = "./price.html";
    linkEcon.onclick = function() {pickFlight(data, "Economy");}
    linkEcon.innerHTML = "$200";
    economy.appendChild(linkEcon);

    var economyPlus = row.insertCell();
    economyPlus.setAttribute("id","ecoPlusCol");
    var linkEconPlus = document.createElement("a");
    linkEconPlus.href = "./price.html";
    linkEconPlus.onclick = function() {pickFlight(data, "Economy Plus")};
    linkEconPlus.innerHTML = "$500";
    economyPlus.appendChild(linkEconPlus);

    var business = row.insertCell();
    business.setAttribute("id","businessCol");
    var linkBusiness = document.createElement("a");
    linkBusiness.href = "./price.html";
    linkBusiness.onclick = function() {pickFlight(data, "Business")};
    linkBusiness.innerHTML = "$800";
    business.appendChild(linkBusiness);


}

function noFlights() {
    console.log("No flights");
}

function pickFlight(flight, fare) {
    var flight_picked = {"flight":flight, "fare":fare, "travelers": travelers};
    localStorage.setItem("flight", JSON.stringify(flight_picked));
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