var test;
kakule.itinerary = {
	init : function(){
		if (!$("itinerary")){return;}
		$('.day').each(function(i, d){
			var today = $(d);
			var beginning_of_day = new Date(today.attr("id")*1000);
			$('.element', today).each(function(i, elem){
				var element = $(elem);
				var startTime = new Date($(".start_time", element).attr("title")*1000);
				var endTime = new Date($(".end_time", element).attr("title")*1000);
				var dayHeight = 360;
				var height = Math.round(((endTime - startTime)/(1000*3600))*(dayHeight/24));
				var yPos = Math.round(((startTime - beginning_of_day)/(1000*3600))*(dayHeight/24));
				var colorSeed = parseInt(element.attr('id'), 10);
				
				element.height(height+"px");
				element.width("10px");
				element.css("margin-top", yPos+"px");
				element.css("background-color", "hsl("+[Math.round(360/colorSeed), "100%", "70%"].join(",")+")");
			})
		})
		
		kakule.itinerary.poshyTip();
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