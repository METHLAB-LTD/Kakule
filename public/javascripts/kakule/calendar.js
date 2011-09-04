if (!kakule.questions) {
  kakule.questions = {};
}

kakule.questions = {
	init : function(){
		if (!$("body#questions")) { return; }
    $('#calendar').fullCalendar({
    })

    var view = $("#calendar").fullCalendar("getView");
    view.visStart = new Date();
    console.log(view);
	},
	
	poshyTip : function(){
		$('.poshytip').poshytip({
					className: 'tip-yellowsimple',
					showTimeout: 1,
					alignTo: 'cursor',
					alignX: 'left',
					alignY: 'bottom',
					offsetY: 7,
					offsetX: 5,
					allowTipHover: true,
					fade: true,
					slide: false
				});
	}
	
}
