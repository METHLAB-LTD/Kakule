if (!kakule.questions) {
  kakule.questions = {};
}

kakule.questions = {
	init : function(){
		if (!$("body#questions")) { return; }
		
		var itineraryId = $("span#itinerary_id").html();
    $('#calendar').fullCalendar({
      weekMode: "variable",
			buttonText: {
        today: '&nbsp;Today&nbsp;'
      },
      editable: true,
			events: '/itineraries/'+itineraryId+'/timeline'
    })
	},

	
}

          //   eventClick: function (calEvent, jsEvent, view) {
          //     PBL.overlay.events.show(calEvent);
          //     jsEvent.preventDefault();
          //   },
          //   eventRender: function (event, el) {
          //     $(el).attr("id", event.id);
          //     if (attendingIds[event.id]) {
          //       $(el).addClass("attending");
          //     }
          //   }
          // });
