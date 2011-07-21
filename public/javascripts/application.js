if (!kakule) {
  var kakule = {};
}

kakule.current = {
	lat: 0,
	lng: 0,
	location: undefined,
	addpanel : {
		selected_search : 0
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

    attachEditHandlers : function() {
        $("#itinerary-name").editInPlace({
		    url: '/itineraries/edit_name',
		    show_buttons: true
	    });
    },
	
	attachSearchHandlers : function(){
		var search_fields = $(".search_field");
		
		var selectUp = function(){
			if (kakule.current.addpanel.selected_search > 1){
				kakule.current.addpanel.selected_search--;
			}
		};
		
		var selectDown = function(results){
			if (kakule.current.addpanel.selected_search < results.children(".result").length){
				kakule.current.addpanel.selected_search++;
			}
		};
		
	  
		$("body").delegate(".search_field", "keyup", function(evt){
			var textBox = $(this);
			var results = $(textBox).parent().parent().siblings(".results").first();
			var func = textBox.attr("id").split("_")[1];
			
			switch (evt.keyCode) {
				case 38: //up arrow
				  selectUp();
				  break;
				case 40: //down arrow
				  selectDown(results);
				  break;
				case 13:
				  break;
				default:
				  kakule.search[func](textBox.val());
			}
			
			var selected = $(".result:nth-child("+ kakule.current.addpanel.selected_search +")", results)
			if (evt.keyCode == 13) {
				// Pin location
				console.log(selected.attr("class").match(/\d+/)[0]);
			}
			
		  kakule.ui.selectSearchResult(selected);
		});
		
    $("body").delegate(".search_form", "submit", function(e) {
        e.preventDefault();
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
		var resultsDiv =  $("#locations .results");
    resultsDiv.empty();
    resultsDiv.append(data.html);

    $.each($(".name", resultsDiv), function(i, div){
	    kakule.ui.highlight(div, data.query);
    });
		
	},

  repopulateAttractions : function(data) {
		var resultsDiv = $("#attractions .results")
    resultsDiv.empty();
    resultsDiv.append(data.html);

    $.each($(".name", resultsDiv), function(i, div){
	    kakule.ui.highlight(div, data.query);
    });

  },

  setLocation : function(location) {
    $("#current_location").text(location);
  },

  highlight : function(location, text){
	  var div = $(location);
	  if (div.html()){
			var regex = new RegExp(text, 'ig');
			div.html(div.html().replace(regex, function(match){
				return '<span class="highlight">' + match + '</span>';
			}));
	  }
  },

  selectSearchResult : function(result){
	  $(result).siblings().removeClass("selected");
	  $(result).addClass("selected");
  }
	
};

$(document).ready(function() {
    kakule.init.getLocation();
    kakule.init.attachAddHandlers();
    kakule.init.attachSearchHandlers();
		kakule.init.attachEditHandlers();
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

