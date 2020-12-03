

function fillOutPriceSummary() {
    if(localStorage.getItem("flight") === null)
        window.location.replace('../airlineweb.html');

    //Price info
    var price;
    if(flight.fare === "Economy")
        price = flight.flight.econPrice;
    else if(flight.fare === "Economy Plus")
        price = flight.flight.econPlusPrice;
    else
        price = flight.flight.businessPrice;


    document.getElementById("bag-fee").lastElementChild.innerHTML = "<sup>$</sup>0.00";
    document.getElementById("subtotal").lastElementChild.innerHTML = "<sup>$</sup>"+ ((price-(0.0825*price))*flight.travelers).toFixed(2);
    document.getElementById("taxes-fees").lastElementChild.innerHTML = "<sup>$</sup>"+((0.0825*price)*flight.travelers).toFixed(2);
    document.getElementById("total").lastElementChild.innerHTML = "<sup>$</sup>"+(price*flight.travelers).toFixed(2);
}



