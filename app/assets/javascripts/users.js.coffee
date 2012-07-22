# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready =>
	dialogOptions = { autoOpen: false,	show: "explode", hide: "explode" }
	register = (tag) -> 
		$("#edit-" + tag + "-dialog").dialog( dialogOptions ) 
		$("#edit-" + tag + "-button").click =>  
			$("#edit-" + tag + "-dialog").dialog( "open" )
			false
		# click cb	
	# register
	register dialog for dialog in ['user','location']
# ready callback
