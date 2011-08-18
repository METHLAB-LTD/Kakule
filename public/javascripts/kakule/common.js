kakule.util = {
	lookupLocationName : function(position) {
		/* Save to temporary variables */
		kakule.current.lat = position.coords.latitude;
		kakule.current.lng = position.coords.longitude;

		/* Find location name */
		var cacheName = "currentLocation";
		var cacheExpirationMin = 60;
		var cachedLocation = kakule.storage.load(cacheName);
		var callback = function(data) {
	    kakule.current.location = data.location;
			kakule.storage.save(cacheName, data, cacheExpirationMin);
	    kakule.home.ui.setLocation(kakule.current.location);
		}
		if (cachedLocation){
			callback(cachedLocation);
		} else {
			$.post("/search/locations", {lat: kakule.current.lat, lng: kakule.current.lng}, callback);
		}
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
	},
	
	set_time_zone_offset : function(){
	    var current_time = new Date();
	    $.cookie('time_zone', current_time.getTimezoneOffset());
	}
	
};


kakule.storage = {
	save : function(key, jsonData, expirationMin){
		if (!Modernizr.localstorage){return false;}
		var expirationMS = expirationMin * 60 * 1000;
		var record = {value: JSON.stringify(jsonData), timestamp: new Date().getTime() + expirationMS}
		localStorage.setItem(key, JSON.stringify(record));
		return jsonData;
	},
	load : function(key){
		if (!Modernizr.localstorage){return false;}
		var record = JSON.parse(localStorage.getItem(key));
		if (!record){return false;}
		return (new Date().getTime() < record.timestamp && JSON.parse(record.value));
	}
}

kakule.server = {
	searchLocations : function(data, callback){
		$.get("/search/render_geocoding", data, callback);
	},
	
	searchAttractions : function(data, callback) {
        $.get("/search/render_attractions", data, callback);
	},
	
	searchMeals : function(data, callback) {
        $.get("/search/render_meals", data, callback);
	}
};