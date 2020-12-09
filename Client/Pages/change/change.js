
const changeInfo = JSON.parse(localStorage.getItem("changeInfo"));

async function getBooking(changeInfo, type) {
    try {
        const response = await fetch("http://localhost:5000/booking/?"+$.param({
            firstName: changeInfo.firstName,
            lastName: changeInfo.lastName,
            bookRef: changeInfo.bookRef,
            type: type
        }));
        let resp = await response.json();
        localStorage.setItem('flight', JSON.stringify(resp));
    }
    catch (err) {
        console.log(err.message);
    }
}

function startDatepicker() {
    var today = new Date();
    var max = new Date();
    max.setDate(max.getDate()+61);
    $('#date').datepicker({
        dateFormat: "mm/dd/yy",
        minDate: today,
        maxDate: max,
        altFormat: "yy-mm-dd",
        altField: "#alt-date"

    });
}

function displayPassengers() {
    window.passengers = JSON.parse(localStorage.getItem("flight")).travelers;
    var passBlockContent = document.getElementsByClassName("block-content")[0];
    var passengerBlock;
    passengers.forEach(function(pass) {
       passengerBlock =
        `<div class="input-field">
            <label class="encompassing-label">
                <input type="checkbox" class="passenger">
                    ${pass.first_name} ${pass.last_name}
            </label>
        </div>`;
        passBlockContent.innerHTML += passengerBlock;

    });
}
function getPassengersCancel() {
    var checkboxes = Array.from(document.getElementsByTagName("input"));
    var checkboxCheck = checkboxes.map(input => {return input.checked});
    var passengersChecked = window.passengers.filter((pass, index) => {return checkboxCheck[index]});
    passengersChecked = passengersChecked.map(pass => {return pass.id});

    if(passengersChecked.length === 0)
    {
        alert("Please select at least one passenger.");
        return false;
    }
    var changeInfo = JSON.parse(localStorage.getItem("changeInfo"));
    changeInfo.travelersCancel = passengersChecked;
    localStorage.setItem("changeInfo", JSON.stringify(changeInfo));

}

