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
	        // if(kakule.util.openAction("attractions")) {
	        //     kakule.server.searchAttractions(kakule.ui.repopulateList);
	        // }
	    });

	    $("#meals .heading").click(function() {
	        $("#meals .search").toggle();
	    });
	},
	
	attachSearchHandlers : function(){
		var search_fields = $(".search_form");
	  
		search_fields.submit(function(evt){
			var text_box = $(".search_field", this);
			var css_class = text_box.attr("id");
			func = css_class.split("_")[1];
			kakule.search[func](text_box.val());
			text_box.val("");
			return false;
		});
		
		
	}
};

kakule.util = {
	lookupLocationName : function(position) {
	    /* Save to temporary variables */
	    kakule.current.lat = position.coords.latitude;
	    kakule.current.long = position.coords.longitude;

	    /* Find location name */
	    $.post("/search/locations", 
	        {lat: kakule.current.lat, long: kakule.current.long},  
	        function(data) {
	          $("#current_location").text(data.location);
	        }
	    );
	},
	
	openAction : function(search) {
	    return $("#" + search + " .search").css("display") != "none";
	},
	
	addCurrentLocationData : function(data){
		data.lat = kakule.current.lat;
		data.long = kakule.current.long;
	}
};


kakule.search = {
	attractions : function(query){
		function callback (response){
			console.log(response.events);
		};
		kakule.server.searchAttractions({'query' : query, 'radius' : 100}, callback);
	},
	
	searchLocations : function(query){
		function callback (response){
			console.log(response);
		};
		kakule.server.searchLocations({'query' : query}, callback);
	}
};


kakule.server = {
	searchLocations : function(data, callback){
		kakule.util.addCurrentLocationData(data);
		$.post("/search/locations", data, callback);
	},
	
	searchAttractions : function(data, callback) {
		kakule.util.addCurrentLocationData(data);
    $.post("/search/events", data, callback);
	},
	
	searchMeals : function(data, callback) {
		kakule.util.addCurrentLocationData(data);
	}
};

kakule.ui = {
	repopulateList : function(data) {
	    console.log(data);
	}
	
	
};










 



$(document).ready(function() {
    kakule.init.getLocation();
    kakule.init.attachAddHandlers();
		kakule.init.attachSearchHandlers();
});

