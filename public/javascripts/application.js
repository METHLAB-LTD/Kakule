if (!kakule) {
  var kakule = {};
}

kakule.current = {
    lat: 0,
    lng: 0,
    location: undefined
};

kakule.init = {
	getLocation : function() {
      if (kakule.util.hasCachedLocationData()) {
        kakule.ui.setLocation(kakule.current.location);
        return;
      }

      console.log("Location not cached, using geolocation");
	  if (Modernizr.geolocation) {
	    navigator.geolocation.getCurrentPosition(kakule.util.lookupLocationName);
	  } else {
	    // no native support; maybe try Gears?
	  }
	},
	
	attachAddHandlers : function() {
	    $("body").delegate("#attractions .heading", "click", function() {
	        $("#attractions .search").toggle();
	        // if(kakule.util.openAction("attractions")) {
	        //     kakule.server.searchAttractions(kakule.ui.repopulateList);
	        // }
	    });

	    $("body").delegate("#meals .heading", "click", function() {
	        $("#meals .search").toggle();
	    });
	},
	
	attachSearchHandlers : function(){
		var search_fields = $(".search_field");
	  
		$("body").delegate(".search_field", "keydown", function(evt){
			var text_box = $(this);
			var css_class = text_box.attr("id");
			func = css_class.split("_")[1];
			kakule.search[func](text_box.val());
		});

        $("body").delegate(".search_form", "submit", function(e) {
            e.preventDefault();
        });
	}
};

kakule.util = {
	lookupLocationName : function(position) {
	    /* Save to temporary variables */
	    kakule.current.lat = position.coords.latitude;
	    kakule.current.lng = position.coords.longitude;

	    /* Find location name */
	    $.post("/search/locations", 
	        {lat: kakule.current.lat, lng: kakule.current.lng},  
            
            function(data) {
                kakule.current.location = data.location;
                kakule.ui.setLocation(kakule.current.location);
            }    
	    );
	},

	openAction : function(search) {
	    return $("#" + search + " .search").css("display") != "none";
	},

    hasCachedLocationData : function() {
        if (typeof kakule.current.location === "undefined") {
            return false;
        } else {
            return true;
        }
    },
	
	addCurrentLocationData : function(data){
		data.lat = kakule.current.lat;
		data.lng = kakule.current.lng;
	}
};


kakule.search = {
	attractions : function(query){
		function callback (response){
            kakule.ui.repopulateAttractions(response);
		};
        console.log(kakule.current.lat);
        console.log(kakule.current.long);
		kakule.server.searchAttractions({'query' : query, 'lat': kakule.current.lat, 'long': kakule.current.long, 'radius' : 10}, callback);
	},
	
	locations : function(query){
		function callback (response){
            kakule.ui.repopulateLocations(response);
		};
		kakule.server.searchLocations({'query' : query}, callback);
	}
};


kakule.server = {
	searchLocations : function(data, callback){
		kakule.util.addCurrentLocationData(data);
		$.get("/search/render_geocoding", data, callback);
	},
	
	searchAttractions : function(data, callback) {
		kakule.util.addCurrentLocationData(data);
       $.get("/search/render_attractions", data, callback);
	},
	
	searchMeals : function(data, callback) {
		kakule.util.addCurrentLocationData(data);
	}
};

kakule.ui = {
	repopulateLocations : function(data) {
	    console.log(data);
        $("#locations .results").empty();
        $("#locations .results").append(data.html);
	},

    repopulateAttractions : function(data) {
        console.log(data);
        $("#attractions .results").empty();
        $("#attractions .results").append(data.html);
    },

    setLocation : function(location) {
	     $("#current_location").text(location);
    }
	
};

$(document).ready(function() {
    kakule.init.getLocation();
    kakule.init.attachAddHandlers();
    kakule.init.attachSearchHandlers();
});

