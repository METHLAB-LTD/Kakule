if (!kakule) {
  var kakule = {};
}

kakule.current = {
    lat: 0,
    long: 0
};

kakule.init = {
	getLocation : function() {
	  if (Modernizr.geolocation) {
	    navigator.geolocation.getCurrentPosition(kakule.util.lookupLocationName);
	  } else {
	    // no native support; maybe try Gears?
	  }
	},
	
	attachAddHandlers : function() {
	    $("#locations .heading").click(function() {
	        $("#locations .search").toggle();
	    });

	    $("#attractions .heading").click(function() {
	        $("#attractions .search").toggle();
	        if(kakule.util.openAction("attractions")) {
	            kakule.server.searchAttractions(kakule.ui.repopulateList);
	        }
	    });

	    $("#meals .heading").click(function() {
	        $("#meals .search").toggle();
	    });
	}
};

kakule.util = {
	lookupLocationName : function(position) {
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
	},
	
	openAction : function(search) {
	    return $("#" + search + " .search").css("display") != "none";
	}
};

kakule.server = {
	searchLocations : function(callback){
		return [];
	},
	
	searchAttractions : function(callback) {
	    $.post("/search/events",
	        {lat: kakule.current.lat, long: kakule.current.long}, 
	        function(data) {
	            callback("attractions", data);
	        }
	    );
	},
	
	
	searchMeals : function(callback) {
	}
}

kakule.ui = {
	repopulateList : function(category, data) {
	    console.log(data);
	}
	
	
}










 



$(document).ready(function() {
    kakule.init.getLocation();
    kakule.init.attachAddHandlers();
});

