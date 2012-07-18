# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready( -> 
	increments = 0;
	timer = setInterval( -> 
		if increments >= 100
			clearInterval(timer)
			$("#now-loading").show( 1000, ->
				$("#now-loading").hide(1000)
			) # show
		# if increments		
		$("#now-loading-bar").css( "width", increments + "%" )
		increments += 9
	, 100 )# timer interval
) # document ready

