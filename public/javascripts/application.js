if (!kakule) {
  var kakule = {};
}

kakule.current = {
    lat: 0,
    lng: 0,
    location: undefined,
    geocode_data: undefined,
    pinned_location: undefined,
    addpanel: {
        selected_search: 0 
    }
};

kakule.init = {
	getLocation : function() {
      if (kakule.util.hasCachedLocationData()) {
        kakule.ui.setLocation(kakule.current.location);
        return;
      }

      //console.log("Location not cached, using geolocation");
	  if (Modernizr.geolocation) {
	    navigator.geolocation.getCurrentPosition(kakule.util.lookupLocationName);
	  } else {
	    // no native support; maybe try Gears?
	  }
	},
	
	attachAddHandlers : function() {
		$("body").delegate(".add-event a", "click", function(e) {
            e.preventDefault();
            var split = $(this).attr("id").split("-");
            var type = split[0];
            var id = parseInt(split[1]);

            $.post("/itineraries/add_event/",
                {type: type, id: id}, 
                function(data) {
                    if (type == "event") {
                        var event = data.obj.event;
                        kakule.ui.addEventToItinerary(event);
                    } else if (type == "attraction") {
                        var attraction = data.obj.attraction;
                        kakule.ui.addAttractionToItinerary(attraction);
                    }
                    
                }
            );
		});

	},

    attachEditHandlers : function() {
        $("#itinerary-name").click(function() {
            $("#itinerary-name").removeClass("itinerary-name-icon");
        });
        $("#itinerary-name").editInPlace({
            callback: function(unused, enteredText) { 
                $.post('/itineraries/edit_name', 
                       { update_value: enteredText }
                      );

                $("#itinerary-name").addClass("itinerary-name-icon");
                return enteredText;
            },
            save_if_nothing_changed: true,
		    show_buttons: false 
	    });
    },
    

	attachSearchHandlers : function(){
        $("#location-search").autocomplete("/search/places", {
            dataType: 'json',
            scroll: false,
            formatItem: function(item) {
                    return item.name;
                },
            parse: function(data) {
                    var array = new Array();
                    for(var i = 0; i < data.length; i++) {
                            array[array.length] = { data: data[i], value: data[i]};
                    }
                    return array;
            },
            highlight: function(value, term) { 
                return value.replace(new RegExp("("+term+")", "gi"),'<span class="ac_highlight">$1</span>'); 
            },
            }).result(function(event, item) {
                kakule.current.lat = item.lat;
                kakule.current.lng = item.lng;

                $("#location-search").val(item.name);
                $.get("/search/render_place_by_id", 
                      {id: item.id},
                      function(data) {
                        $("#content").empty();
                        $("#content").append(data.html);

                        kakule.search.attractions("");
                      });
            });
	},
	
	session : function(){
		var sessionDiv = $("#session");
		var loginLink = $(".login", sessionDiv);
		loginLink.click(function(){
			$(".popup", sessionDiv).toggle(200);
		});
	}
};

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
	    kakule.ui.setLocation(kakule.current.location);
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
						var geocode_data = {};
						$.each(response.data, function(i, entry){
							geocode_data[entry.geocode.id] = entry.geocode;
						});
					  kakule.current.geocode_data = geocode_data;	
		};
		kakule.server.searchLocations({'query' : query}, callback);
	}
};


kakule.server = {
	searchLocations : function(data, callback){
		$.get("/search/render_geocoding", data, callback);
	},
	
	searchAttractions : function(data, callback) {
        $.get("/search/render_attractions", data, callback);
	},
	
	searchMeals : function(data, callback) {
        // TODO
	}
};

kakule.ui = {
  repopulateAttractions : function(data) {
     var resultsDiv = $("#attractions");
     resultsDiv.empty();
     resultsDiv.append(data.html);
  },

  addEventToItinerary : function(event) {
    $("#itinerary-day").append(
        $("<div></div>")
            .addClass("itinerary-event")
            .text(event.name)
    );
  },

  addAttractionToItinerary : function(attraction) {
  },

  setLocation : function(location) {
    $("#current_location").text(location);
  },
};

$(document).ready(function() {
    //kakule.init.getLocation();
    kakule.init.attachSearchHandlers();
	kakule.init.attachEditHandlers();
    kakule.init.attachAddHandlers();
	kakule.init.session()


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

