function getUrlVars(url) {
    var vars = [], hash;
    var hashes = url.slice(url.indexOf('?') + 1).split('&');
    for(var i = 0; i < hashes.length; i++)
    {
        hash = hashes[i].split('=');
        vars.push(hash[1]);
    }
    return vars;
}

function render_calendar(e) {
    e.preventDefault();
    var urlVars = getUrlVars($(this).attr("href"));
    $.get("/calendar/render_calendar", 
          {month: urlVars[0], year: urlVars[1]},
          function(data) {
            $("#calendar").empty();
            $("#calendar").append(data.html);
          }
    );
}

function choose_day(e) {
    var date = $(this).attr("id");

    $(".ec-today-header").removeClass("ec-today-header");
    $(this).addClass("ec-today-header");

    $.get("/itineraries/render_day",
          {date: date},
          function(data) {
            $("#addpanel").empty();
            $("#addpanel").append(data.html);
            kakule.init.getLocation();
          }
    );
}

$(document).ready(function() {
    $("body").delegate(".ec-previous-month a", "click", render_calendar);
    $("body").delegate(".ec-next-month a", "click", render_calendar);
    $("body").delegate(".ec-day-header", "click", choose_day);
});
