

//STILL HAVE ACCESS TO VARIABLE flight FROM price.js


var passengers = [];

function travelerInfo() {
    for(i=1;i<=flight.travelers; i++)
    {
        const passengerNum = i;
        var block =document.createElement("DIV");
        block.className += "passenger-info block-section";
        block.id = "passenger" + i;
        document.getElementsByClassName("passenger-info block")[0].appendChild(block);
        $('#passenger'+i).load("/hw4/Client/Components/passengerInfo.html", function() {
            this.getElementsByClassName("subtitle")[0].innerHTML += passengerNum;
        });
        passengers.push(block);
    }
}
travelerInfo();

// passengers[0].querySelectorAll('.firstName').value;
