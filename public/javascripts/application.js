function getLocation() {
  if (Modernizr.geolocation) {
    navigator.geolocation.getCurrentPosition(lookupLocationName);
  } else {
    // no native support; maybe try Gears?
  }
}

function lookupLocationName(position) {
    $.post("/search/location", 
        {lat: position.coords.latitude, long: position.coords.longitude},  
        function(data) {
          $("#current_location").text(data.location);
        }
    );
}

$(document).ready(function() {
    getLocation();
});

