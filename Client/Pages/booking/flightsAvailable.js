
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
        if(flights[0].length === 0 && flights[1].length === 0) {
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

function insertInfo(row, data, directFlight) {
    //Depart time
    var departing = row.insertCell();
    var departTime = new Date(data.scheduled_departure);
    departing.innerHTML = convertTime(departTime);
    //Arrive time
    var arriving = row.insertCell();
    var arriveTime  = new Date(data.scheduled_arrival);
    arriving.innerHTML = convertTime(arriveTime);
    var stops = row.insertCell();
    if(directFlight)
        stops.innerHTML = "Nonstop";
    else
        stops.innerHTML = "1 stop";
    //Flight time

    var flightLength = row.insertCell();
    flightLength.innerHTML = data.duration;
    //Fare pricing
    var economy = row.insertCell();
    economy.setAttribute("id", "ecoCol");
    var linkEcon = document.createElement("a");
    linkEcon.href = "./price.html";
    linkEcon.onclick = function() {pickFlight(data, "Economy");}
    linkEcon.innerHTML = "$"+data.econPrice.toFixed(0);
    economy.appendChild(linkEcon);

    var economyPlus = row.insertCell();
    economyPlus.setAttribute("id","ecoPlusCol");
    var linkEconPlus = document.createElement("a");
    linkEconPlus.href = "./price.html";
    linkEconPlus.onclick = function() {pickFlight(data, "Economy Plus")};
    linkEconPlus.innerHTML = "$"+data.econPlusPrice.toFixed(0);
    economyPlus.appendChild(linkEconPlus);

    var business = row.insertCell();
    business.setAttribute("id","businessCol");
    var linkBusiness = document.createElement("a");
    linkBusiness.href = "./price.html";
    linkBusiness.onclick = function() {pickFlight(data, "Business")};
    linkBusiness.innerHTML = "$"+data.businessPrice.toFixed(0);
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

    if(flights[0].length > 0)
    {
        document.getElementById("departCity").innerHTML = flights[0][0].depart_city.trim();
        document.getElementById("arriveCity").innerHTML = flights[0][0].arrive_city.trim();
    }
    else if(flights[1].length > 0)
    {
        document.getElementById("departCity").innerHTML = flights[1][0].depart_city.trim();
        document.getElementById("arriveCity").innerHTML = flights[1][0].arrive_city.trim();
    }

    var table = document.getElementById("flightsTable").getElementsByTagName('tbody')[0];
    flights.forEach(function(type, i) {
        type.forEach(function(flight) {
            var row = table.insertRow();
            if(i===0) //Direct Flight
                insertInfo(row, flight, true);
            else
                insertInfo(row, flight, false);
        });
    });
}