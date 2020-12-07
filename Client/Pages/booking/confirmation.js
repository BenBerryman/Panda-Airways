
var response = JSON.parse(localStorage.getItem("response"));
// document.getElementById("bookRef").innerHTML = response.bookRef;
var passengers = response.travelers;
passengers.forEach(function(pass) {
    var dob = pass.date_of_birth.toString().substr(0,10);
    dob = dob.split("-").reverse().join("/");

    var parent = document.createElement("DIV");
    parent.classList.add("passenger");

    var name = document.createElement("DIV");
    name.classList.add("name");
    name.innerHTML = `${pass.first_name} ${pass.last_name}`;
    parent.appendChild(name);

    var spacer = document.createElement("DIV");
    spacer.classList.add("spacer");
    parent.appendChild(spacer);

    var dobElem = document.createElement("DIV");
    dobElem.classList.add("dob");
    dobElem.innerHTML=dob;
    parent.appendChild(dobElem);

    document.getElementsByClassName("passenger-info")[0].appendChild(parent);
});
document.getElementById("cardNum").innerHTML += response.payment.cardLastFour;
document.getElementById("totalAmount").innerHTML ="$"+ response.payment.amount;

function clearLocalStorage() {
    localStorage.removeItem("date");
    localStorage.removeItem("flight");
    localStorage.removeItem("changeInfo");
    localStorage.removeItem("response");
}