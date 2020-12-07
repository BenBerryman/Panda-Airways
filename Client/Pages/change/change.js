
const changeInfo = JSON.parse(localStorage.getItem("changeInfo"));

async function getBooking(changeInfo) {
    try {
        const response = await fetch("http://localhost:5000/booking/?"+$.param({
            firstName: changeInfo.firstName,
            lastName: changeInfo.lastName,
            bookRef: changeInfo.bookRef,
            type: 'passengerCount'
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

