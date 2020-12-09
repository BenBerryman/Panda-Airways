

function fillOutPriceSummary(flight) {

    //Price info
    var price;
    var priceWithTax;
    switch(flight.fare)
    {
        case 'Economy':
            price = flight.flight.econPrice;
            priceWithTax = flight.flight.econWithTax;
            break;
        case 'Economy Plus':
            price = flight.flight.econPlusPrice;
            priceWithTax = flight.flight.econPlusWithTax;
            break;
        case 'Business':
            price = flight.flight.businessPrice;
            priceWithTax = flight.flight.businessWithTax;
    }
    document.getElementById("bagFee").lastElementChild.innerHTML = "<sup>$</sup>0.00";
    document.getElementById("subtotal").lastElementChild.innerHTML = "<sup>$</sup>"+ (price*flight.travelers).toFixed(2);
    document.getElementById("taxesFees").lastElementChild.innerHTML = "<sup>$</sup>"+((priceWithTax-price)*flight.travelers).toFixed(2);
    document.getElementById("total").lastElementChild.innerHTML = "<sup>$</sup>"+(priceWithTax*flight.travelers).toFixed(2);
}

async function fillOutPriceDifference(type='change') {
    var priceDiff;
    var booking;
    switch(type)
    {
        case 'change':
            priceDiff = await fetch("http://localhost:5000/priceDiff?"+$.param({
                oldFlight: JSON.parse(localStorage.getItem("flight")),
                newFlight: JSON.parse(localStorage.getItem("newFlight")),
                type: 'change'
            }));
            priceDiff = await priceDiff.json();

            booking = await fetch("http://localhost:5000/booking?"+$.param({
                bookRef: JSON.parse(localStorage.getItem("changeInfo")).bookRef,
                type:'cardNumber'
            }));
            booking = await booking.json();

            //New flight price info

            // document.getElementById("priceDiff").lastElementChild.innerHTML = "<sup>$</sup>"+ ((price-(0.0825*price))*flight.travelers).toFixed(2);
            // document.getElementById("taxesFees").lastElementChild.innerHTML = "<sup>$</sup>"+((0.0825*price)*flight.travelers).toFixed(2);
            document.getElementById("refundOrPayment").innerHTML = priceDiff.refund ? "refunded" : "charged";
            document.getElementById("total").lastElementChild.innerHTML = "<sup>$</sup>"+priceDiff.priceDiff;
            document.getElementById("lastFourDigits").innerHTML += booking.cardLastFour;
            document.getElementById("blockTextAmount").innerHTML = "$"+Math.abs(priceDiff.priceDiff).toFixed(2);
            break;
        case 'cancel':
            priceDiff = await fetch("http://localhost:5000/priceDiff?"+$.param({
                oldFlight: JSON.parse(localStorage.getItem("flight")),
                travelersCancel: JSON.parse(localStorage.getItem("changeInfo")).travelersCancel,
                type: 'cancel'
            }));

            priceDiff = await priceDiff.json();
            var travelerCount = JSON.parse(localStorage.getItem("flight")).travelers.length;
            booking = await fetch("http://localhost:5000/booking?"+$.param({
                bookRef: JSON.parse(localStorage.getItem("changeInfo")).bookRef,
                type:'cardNumber'
            }));
            booking = await booking.json();
            document.getElementById("priceDiff").lastElementChild.innerHTML = "<sup>$</sup>"+priceDiff.priceDiff;
            document.getElementById("newPassCount").lastElementChild.innerHTML = "x"+ (travelerCount-JSON.parse(localStorage.getItem("changeInfo")).travelersCancel.length);
            document.getElementById("total").lastElementChild.innerHTML = "<sup>$</sup>"+priceDiff.newTotal.toFixed(2);
            document.getElementById("lastFourDigits").innerHTML += booking.cardLastFour;
            document.getElementById("blockTextAmount").innerHTML = "$"+Math.abs(priceDiff.priceDiff).toFixed(2);
    }

}

async function finalizeChange(type) {
    try {
        var info;
        var method;
        switch(type)
        {
            case 'change':
                info = {
                    bookRef: JSON.parse(localStorage.getItem("changeInfo")).bookRef,
                    oldFlight: JSON.parse(localStorage.getItem("flight")),
                    newFlight: JSON.parse(localStorage.getItem("newFlight"))
                };
                method='PUT';
                break;
            case 'cancel':
                info = {
                    bookRef: JSON.parse(localStorage.getItem("changeInfo")).bookRef,
                    oldFlight: JSON.parse(localStorage.getItem("flight")),
                    travelersCancel: JSON.parse(localStorage.getItem("changeInfo")).travelersCancel
                };
                method='DELETE';
                break;
        }

        const response = await fetch("http://localhost:5000/purchase",
            {method: method,
                headers: {"Content-Type": "application/json"},
                body: JSON.stringify(info)});
        if(response.status === 200)
        {
            var resp = await response.json();
            localStorage.setItem("response", JSON.stringify(resp));
            if(type==='change')
                window.location.replace("./changeConfirmation.html");
            else
                window.location.replace("./cancelConfirmation.html");
        }
        else if(response.status === 500) {
            errorChanging();
        }
    } catch(err) {
        console.log(err.message);
    }
}

function errorChanging() {
    alert("We're sorry, there was an issue processing your request. Please try again.");
    window.reload();
}



