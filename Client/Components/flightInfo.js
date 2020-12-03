
async function defineFlight() {
    var locStorage = localStorage.getItem('flight');
    window.flight = await getFlight(JSON.parse(locStorage));
    insertInfo(window.flight);
}

async function getFlight(flight) {
    if(flight.flight2 === undefined)
        var resp = await fetch(`http://localhost:5000/getFlight?id=${flight.flight}`);
    else
        var resp = await fetch(`http://localhost:5000/getFlight?id=${flight.flight}&id2=${flight.flight2}`);
    let selection = await resp.json();
    return {flight: selection, fare: flight.fare,travelers: flight.travelers};
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

function insertInfo(selection) {
    var dateDepart = new Date(selection.flight.scheduled_departure);
    var dateArrive = new  Date(selection.flight.scheduled_arrival);
    var weekday=new Array(7);
    weekday[0]="Sun";
    weekday[1]="Mon";
    weekday[2]="Tues";
    weekday[3]="Wed";
    weekday[4]="Thur";
    weekday[5]="Fri";
    weekday[6]="Sat";
    var month = dateDepart.getMonth()+1;
    var dayOfMonth = dateDepart.getDate();

    var boardTime = convertTime(dateDepart);
    var arriveTime = convertTime(dateArrive);


    document.getElementById("date").innerHTML = `${weekday[dateDepart.getDay()]} ${month}/${dayOfMonth}`;
    var airportCodes = document.getElementsByClassName("airport-code-bold");
    airportCodes[0].innerHTML = selection.flight.depart;
    airportCodes[1].innerHTML = selection.flight.arrive;
    var times = document.getElementsByClassName("flight-time");
    times[0].innerHTML = boardTime;
    times[1].innerHTML = arriveTime;

    var res = Math.abs(dateArrive - dateDepart) / 1000;
    var hoursBetween = Math.floor(res / 3600) % 24;
    var minutesBetween = Math.floor(res / 60) % 60;
    document.getElementById("flightTime").innerHTML = selection.flight.duration;

    var connection = document.getElementsByClassName("connection")[0];
    if(selection.flight.conn1 === undefined)
        connection.innerHTML = "Nonstop";
    else
        connection.innerHTML = "1 stop";

    document.getElementById("fare").innerHTML = selection.fare;


    //Price info
    var price;
    if(flight.fare === "Economy")
        price = flight.flight.econPrice;
    else if(flight.fare === "Economy Plus")
        price = flight.flight.econPlusPrice;
    else
        price = flight.flight.businessPrice;
    document.getElementsByClassName("price-per-pass")[0].lastElementChild.innerHTML = "$"+(price-(0.0825*price)).toFixed(2);
    document.getElementsByClassName("taxes-per-pass")[0].lastElementChild.innerHTML = "$"+(0.0825*price).toFixed(2);
    document.getElementsByClassName("total-per-pass")[0].lastElementChild.innerHTML = "$"+price.toFixed(2);
    document.getElementsByClassName("passengers")[0].lastElementChild.innerHTML = "x"+flight.travelers;
    document.getElementsByClassName("flight-total")[0].lastElementChild.innerHTML = "<sup>$</sup>"+(price*flight.travelers).toFixed(2);

}