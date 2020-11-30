
const query = window.location.search;
const urlParams = new URLSearchParams(query);
var from = urlParams.get('from');
var to = urlParams.get('to');
var date = localStorage.getItem("date");
var fare = urlParams.get('fare');
var travelers = urlParams.get('travelers');
let flights = [];
let table = document.getElementById("flightsTable").getElementsByTagName('tbody')[0];

document.getElementById("depart").innerHTML = from;
document.getElementById("arrive").innerHTML = to;
getCities(from)
    .then((value)=>document.getElementById("departCity").innerHTML = value);
getCities(to)
    .then((value)=>document.getElementById("arriveCity").innerHTML = value);
document.getElementById("alt-date").value = date;
findFlights();

function changeDate() {
    date = document.getElementById("alt-date").value;
    while (table.childNodes.length > 2) {
        table.removeChild(table.lastChild);
    }
    findFlights();
}

async function getCities(airportCode) {
    try {
        const response = await fetch(`http://localhost:5000/city?airport_code=${airportCode}`);
        return await response.json();
    } catch(err) {
        console.log(err.message);
    }
}
async function findFlights() {
    try {
        const response = await fetch("http://localhost:5000/findFlights/?"+$.param({
            from: from,
            to: to,
            date: date,
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
    var min = time.getMinutes().toString();
    var AmOrPm = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if(hour===0)
        hour = 12;
    if(min.length<2)
        min = "0"+min;
    return hour.toString() + ":" + min + AmOrPm;
}

function insertInfo(row, data) {
    //Depart time
    var departing = row.insertCell();
    var departTime = new Date(data.scheduled_departure);
    departing.innerHTML = convertTime(departTime);
    //Arrive time
    var arriving = row.insertCell();
    var arriveTime  = new Date(data.scheduled_arrival);
    arriving.innerHTML = convertTime(arriveTime);
    var stops = row.insertCell();
    if(data.conn1 === undefined)
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
    document.getElementsByClassName("container")[1].style.display = "none";
    document.getElementsByClassName("no-flights")[0].style.display = "block";
}

function pickFlight(flight, fare) {
    var flight_picked = {"flight":flight.id, "fare":fare, "travelers": travelers};
    if(flight.conn1_id !== undefined)
        flight_picked.flight2 = flight.conn1_id;
    localStorage.removeItem("date");
    localStorage.setItem("flight", JSON.stringify(flight_picked));
}

function showFlights() {
    document.getElementsByClassName("container")[1].style.display = "block";
    document.getElementsByClassName("no-flights")[0].style.display = "none";
    flights.forEach(function(type, i) {
        type.forEach(function(flight) {
            var row = table.insertRow();
            insertInfo(row, flight);
        });
    });
}

$(document).ready(()=>{
    var today = new Date();
    var max = new Date();
    max.setDate(max.getDate()+61);
    $('#date').datepicker({
    dateFormat: "mm/dd/yy",
    minDate: today,
    maxDate: max,
    altFormat: "yy-mm-dd",
    altField: "#alt-date"
})});