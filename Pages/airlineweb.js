

$("#slideshow > img:gt(0)").hide();

setInterval(function() {
    $('#slideshow > img:first')
        .fadeOut(2500)
        .next()
        .show()
        .end()
        .appendTo('#slideshow');
}, 25000);

