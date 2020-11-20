

$("#slideshow > img:gt(0)").hide();

setInterval(function() {
    $('#slideshow > img:first')
        .fadeOut(2500)
        .next()
        .show()
        .end()
        .appendTo('#slideshow');
}, 25000);

$(document).ready(function() {
    $('#book').show();
    $('#status').hide();

    var date = new Date();
    var dd = ('0'+date.getDate()).slice(-2);
    var mm = ('0'+(date.getMonth()+1)).slice(-2);
    var yyyy = date.getFullYear();
    today = yyyy+'-'+mm+'-'+dd;
    date.setDate(date.getDate()+61);
    dd = ('0'+date.getDate()).slice(-2);
    mm = ('0'+(date.getMonth()+1)).slice(-2);
    yyyy = date.getFullYear();
    max = yyyy+'-'+mm+'-'+dd;
    document.getElementById("dates").setAttribute('min', today);
    document.getElementById("dates").setAttribute('max', max);

    $('#bookShow').click(function() {
        $('#status').hide();
        $('#book').show();
        $('#idCaret').css('left','18.5%');

    });
    $('#statusShow').click(function() {
        $('#book').hide();
        $('#status').show();
        $('#idCaret').css('left','51.7%');
    });
});

function changeText() {
    var value = document.getElementById('travelers').value;
    if(value > 1)
        document.getElementById('travelText').innerHTML = "travelers";
    else
        document.getElementById('travelText').innerHTML = "traveler";
}