# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$( ->
	$("#submit-login-button").tooltip( { title : "...", trigger : "manual" } )
	$("#dialog-login-user-header").popover( { title : "!!!", content : "Login Failed", trigger : "manual" } )
	$("#login_user_form").submit ->
		$("#submit-login-button").tooltip "show" 
		$("#submit-login-button").attr "disabled", true
		setTimeout =>
			$("#submit-login-button").attr "disabled", false
			$("#submit-login-button").tooltip "hide" 
			$("#dialog-login-user-header").popover "show" 
			setTimeout =>
				$("#dialog-login-user-header").popover "hide"
				return false
			, 2000 # timeOut
			return false
		, 2500 # timeOut
		return true
	# click
) # document ready

