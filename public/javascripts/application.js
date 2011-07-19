if (!kakule) {
  var kakule = {};
}

kakule.current = {
    lat: 0,
    lng: 0,
    location: undefined,
    geocode_data: undefined,
    pinned_location: {
        name: undefined,
        lat: undefined,
        lng: undefined
    }
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
	    $("body").delegate(".location-pin", "click", function() {
            // FIXME: Figure out how to parse String -> int
            var i = 0;

            // Save location
            kakule.current.pinned_location.name = kakule.current.geocode_data[i].geocode.name;
            kakule.current.pinned_location.lat = kakule.current.geocode_data[i].geocode.latitude;
            kakule.current.pinned_location.lng = kakule.current.geocode_data[i].geocode.longitude;

            var location_name = kakule.current.pinned_location.name;
            // Replace text box
            // TODO: Leave option to re-edit
            $("#locations .search_form").hide();
            $("#locations .results").hide();
            $("#pinned_location_name").text(location_name);
            $("#pinned_location").show();

            // Open attractions/meals search
            $(".near-label span").text(location_name);
            $(".near-label").show();
            
            // TODO: Search for attractions/meals
            
	    });
	},

    attachEditHandlers : function() {
        $("#itinerary-name").editInPlace({
		    url: '/itineraries/edit_name',
		    show_buttons: true
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
        if (typeof kakule.current.location === "undefined" ||
            typeof kakule.current.lat === "undefined" ||
            typeof kakule.current.lng === "undefined") {
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
		kakule.server.searchAttractions({'query': query, 'lat': kakule.current.lat, 'lng': kakule.current.lng}, callback);
	},
	
	locations : function(query){
		function callback (response){
            kakule.ui.repopulateLocations(response);
            kakule.current.geocode_data = response.data;
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
        $("#locations .results").empty();
        $("#locations .results").append(data.html);
	},

    repopulateAttractions : function(data) {
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
	kakule.init.attachEditHandlers();
		
		// FB.init({
		// 	    appId  : '190781907646255',
		// 	    status : true, // check login status
		// 	    cookie : true, // enable cookies to allow the server to access the session
		// 	    xfbml  : true  // parse XFBML
		// 	  });
		// 	
		// FB.login(function(response) {
		//   if (response.session) {
		// 		console.log(response.session.access_token);
		// 		//POST this access_token to server, and log user in
		//   } else {
		//     // user cancelled login
		//   }
		// });

    

});

