/*
 * Smart event highlighting
 * Handles when events span rows, or don't have a background color
 */
function smartEventHighlighting() {
  var highlight_color = "#2EAC6A";
  
  // highlight events that have a background color
  $(".ec-event-bg").live("mouseover", function() {
    event_id = $(this).attr("data-event-id");
		event_class_name = $(this).attr("data-event-class");
    $(".ec-"+event_class_name+"-"+event_id).css("background-color", highlight_color);
  });
  $(".ec-event-bg").live("mouseout", function() {
    event_id = $(this).attr("data-event-id");
		event_class_name = $(this).attr("data-event-class");
    event_color = $(this).attr("data-color");
    $(".ec-"+event_class_name+"-"+event_id).css("background-color", event_color);
  });
  
  // highlight events that don't have a background color
  $(".ec-event-no-bg").live("mouseover", function() {
    ele = $(this);
    ele.css("color", "white");
    ele.find("a").css("color", "white");
    ele.find(".ec-bullet").css("background-color", "white");
    ele.css("background-color", highlight_color);
  });
  $(".ec-event-no-bg").live("mouseout", function() {
    ele = $(this);
    event_color = $(this).attr("data-color");
    ele.css("color", event_color);
    ele.find("a").css("color", event_color);
    ele.find(".ec-bullet").css("background-color", event_color);
    ele.css("background-color", "transparent");
  });
}

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

$(document).ready(function() {
    $("body").delegate(".ec-previous-month a", "click", render_calendar);
    $("body").delegate(".ec-next-month a", "click", render_calendar);
});
