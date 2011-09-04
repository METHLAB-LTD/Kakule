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
      eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc, jsEvent, ui, view) {
        $.post("/itineraries/drag_event_time", 
               {id: event.id, dayDelta: dayDelta, minuteDelta: minuteDelta});
      },
      eventResize: function(event, dayDelta, minuteDelta, allDay, revertFunc, jsEvent, ui, view) {
        $.post("/itineraries/resize_event_time", 
               {id: event.id, dayDelta: dayDelta, minuteDelta: minuteDelta});
      },

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
