

//STILL HAVE ACCESS TO VARIABLE flight FROM price.js


var passengers = [];

function waitForElement(){
    if(typeof flight !== "undefined"){
        travelerInfo();
    }
    else{
        setTimeout(waitForElement, 250);
    }
}

function travelerInfo() {
    for(i=1;i<=flight.travelers; i++)
    {
        const passengerNum = i;
        var block =document.createElement("DIV");
        block.className += "passenger-info block-section";
        block.id = "passenger" + i;
        document.getElementsByClassName("passenger-info block")[0].appendChild(block);
        $('#passenger'+i).load("../../Components/passengerInfo.html", function() {
            this.getElementsByClassName("subtitle")[0].innerHTML += passengerNum;
            this.getElementsByClassName("firstName")[0].addEventListener('invalid', function() {
                console.log("invalid!");
            });
        });
        passengers.push(block);
    }
}
function checkValidity() {
    var allValid = true;

    return allValid;

}
function validate(element) {
    if(element.checkValidity())
        element.setAttribute("isvalid", "true");
    else
        element.setAttribute("isvalid", "false");
    if(element.type === 'text')
    {
        if(element.value.trim() < 1)
            element.setAttribute("isvalid", "false");
    }
}

async function purchase(e) {
    try
    {   //Get passenger info in 2D array
        var passengerInfo = [];
        passengers.forEach((pass)=>{
            var dobMonth = pass.getElementsByClassName("dobMonth")[0].value;
            var dobDay = pass.getElementsByClassName("dobDay")[0].value;
            var dobYear = pass.getElementsByClassName("dobYear")[0].value;
            var dob = new Date(dobYear, dobMonth-1, dobDay);
            passengerInfo.push(
                {firstName: pass.getElementsByClassName("firstName")[0].value,
                lastName: pass.getElementsByClassName("lastName")[0].value,
                dob: dob});
        });
        const contactInfo =
            {email: document.getElementsByClassName("email")[0].value,
            phone: document.getElementsByClassName("phoneNumber")[0].value};
        //VOUCHER CODE TO BE ADDED TODO

        const paymentInfo =
            {cardNum: document.getElementsByName("cardNum")[0].value,
            expMonth: document.getElementsByName("cardExpiryMonth")[0].value,
            expYear: document.getElementsByName("cardExpiryYear")[0].value};

        const info =
            {flight: flight,
            passengerInfo: passengerInfo,
            contactInfo: contactInfo,
            paymentInfo: paymentInfo};

        const response = await fetch("http://localhost:5000/purchase",
        {method: "POST",
            headers: {"Content-Type": "application/json"},
            body: JSON.stringify(info)});
        let resp = await response.json();
        if(resp.status === "success")
            window.location.replace("./confirmation.html");
        else if(resp.status === "flight_full") {
            //Display error page
        }





    } catch(err) {
        console.log(err.message);
    }
}
waitForElement();


