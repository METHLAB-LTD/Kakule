kakule = {};
kakule.current = {
    lat: 0,
    long: 0
}

function getLocation() {
  if (Modernizr.geolocation) {
    navigator.geolocation.getCurrentPosition(lookupLocationName);
  } else {
    // no native support; maybe try Gears?
  }
}

function lookupLocationName(position) {
    /* Save to temporary variables */
    kakule.current.lat = position.coords.latitude;
    kakule.current.long = position.coords.longitude;

    /* Find location name */
    $.post("/search/location", 
        {lat: kakule.current.lat, long: kakule.current.long},  
        function(data) {
          $("#current_location").text(data.location);
        }
    );
}

function openAction(search) {
    return $("#" + search + " .search").css("display") != "none";
}

function searchLocations() {
    return [];
}

function searchAttractions() {
    $.post("/search/events",
        {lat: kakule.current.lat, long: kakule.current.long}, 
        function(data) {
            repopulateList("attractions", data);
        }
    );
}

function searchMeals() {
}

function repopulateList(category, data) {
    console.log(data);
}

function attachAddHandlers() {
    $("#locations .heading").click(function() {
        $("#locations .search").toggle();
    });

    $("#attractions .heading").click(function() {
        $("#attractions .search").toggle();
        if(openAction("attractions")) {
            searchAttractions();
        }
    });

    $("#meals .heading").click(function() {
        $("#meals .search").toggle();
    });
}

$(document).ready(function() {
    getLocation();
    attachAddHandlers();
});

