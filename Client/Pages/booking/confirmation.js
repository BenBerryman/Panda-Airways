

function fillOutResponseInfo(type) {
    var amount;
    var perPassenger;
    switch(type) {
        case 'cancel':
            var cancelType = JSON.parse(localStorage.getItem("response")).type;
            if (cancelType === 'partialDelete') {
                document.getElementById("content-container").innerHTML =
                    `<div class="block-text" style="margin-bottom: 22px;">
                        <p>Your flight reservation has been successfully cancelled for the passengers selected. Below are the passengers remaining.</p>
                    </div>

                    <div class="two-block-section">
                        <div class="passenger-container block">
                            <div class="block-title passengers">Passenger Info</div>
                            <div class="block-section">
                                <div class="subtitle">
                                    <div class="name">NAME</div>
                                    <div class="spacer"></div>
                                    <div class="dob">DATE OF BIRTH</div>
                                </div>
                                <div class="passenger-info"></div>
                            </div>
                
                        </div>
                
                        <div class="payment-container block">
                            <div class="block-title payment">Payment Info</div>
                            <div class="block-section">
                                <div class="payment-info">
                                    <div class="cardNum">
                                        <span>Card Number</span>
                                        <span id="cardNum">xxxxxxxxxxxx</span>
                                    </div>
                                    <div class="total-amount">
                                        <span>Total Amount</span>
                                        <span id="totalAmount"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>`;
            } else {
                document.getElementById("content-container").innerHTML = "Your flight reservation has been successfully cancelled.";
                document.getElementById("content-container").setAttribute("style", "text-align: center; font-weight: bold; font-size: 15pt; padding: 15px 0");
                break;
            }
        case 'change':
            var response = JSON.parse(localStorage.getItem("response"));
            if (document.getElementById("bookRef") !== null)
                document.getElementById("bookRef").innerHTML = response.bookRef;

            var passengers = response.travelers;
            passengers.forEach(function (pass) {
                var dob = pass.date_of_birth.toString().substr(0, 10);
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
                dobElem.innerHTML = dob;
                parent.appendChild(dobElem);

                document.getElementsByClassName("passenger-info")[0].appendChild(parent);
            });
            document.getElementById("cardNum").innerHTML += response.payment.cardLastFour;
            document.getElementById("totalAmount").innerHTML = "$" + response.payment.amount;

    }
}

function clearLocalStorage() {
    localStorage.removeItem("date");
    localStorage.removeItem("flight");
    localStorage.removeItem("newFlight");
    localStorage.removeItem("changeInfo");
    localStorage.removeItem("response");
}