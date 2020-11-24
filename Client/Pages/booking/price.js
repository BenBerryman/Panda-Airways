

var flight = JSON.parse(localStorage.getItem('flight'));
// document.getElementById("depart").innerHTML = flight.flight.depart;
// document.getElementById("arrive").innerHTML = flight.flight.arrive;

function convertTime(time) {
    var hour = time.getHours();
    var min = time.getMinutes();
    var AmOrPm = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if(hour===0)
        hour = 12;
    return hour.toString() + ":" + min.toString() + AmOrPm;
}

var dateDepart = new Date(flight.flight.scheduled_departure);
var dateArrive = new  Date(flight.flight.scheduled_arrival);
var weekday=new Array(7);
weekday[0]="Sun";
weekday[1]="Mon";
weekday[2]="Tues";
weekday[3]="Wed";
weekday[4]="Thur";
weekday[5]="Fri";
weekday[6]="Sat";
console.log(weekday[dateDepart.getDay()]);
var month = dateDepart.getMonth()+1;
var dayOfMonth = dateDepart.getDate();

var boardTime = convertTime(dateDepart);
var arriveTime = convertTime(dateArrive);


document.getElementById("date").innerHTML = `${weekday[dateDepart.getDay()]} ${month}/${dayOfMonth}`;
var airportCodes = document.getElementsByClassName("airport-code-bold");
airportCodes[0].innerHTML = flight.flight.depart;
airportCodes[1].innerHTML = flight.flight.arrive;
var times = document.getElementsByClassName("flight-time");
times[0].innerHTML = boardTime;
times[1].innerHTML = arriveTime;

var res = Math.abs(dateArrive - dateDepart) / 1000;
var hoursBetween = Math.floor(res / 3600) % 24;
var minutesBetween = Math.floor(res / 60) % 60;
document.getElementById("flightTime").innerHTML = hoursBetween.toString()+"h "+minutesBetween+"min";


document.getElementById("fare").innerHTML = flight.fare;

//TODO REMEMBER to clear local storage out after done with transaction


