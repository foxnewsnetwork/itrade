# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	swap_warning = (me,him) ->
		myjunk = $(me).attr "class"
		hisjunk = $("#specify-#{him}-button").attr("class").replace /\s*btn-warning/, ""
		$("#specify-#{him}-button").attr "class", hisjunk
		if !(/btn-warning/.test myjunk)
			$(me).attr "class", myjunk + " btn-warning"
		$("#specify-#{him}-button").attr "disabled", true
		setTimeout ->
			$("#specify-#{him}-button").attr "disabled", false
			return false
		, 1500 # setTimeout
		return false
		# if
	# swap_warning
		
	manage_elements = (who) ->
		$("#unused_label").hide()
		if who == "port"
			$("#unused_name").hide()
			$("#new_yard_form").hide()
			$("#port_id_select_tag").show()
		else
			$("#port_id_select_tag").hide()
			$("#new_yard_form").show()
			$("#unused_name").show()
		# if-else
		$("#location_type_id").attr "value", who
		return false
	# manage_elements
	
	$("#specify-port-button").click ->
		swap_warning this, "yard"
		manage_elements "port"
		return false
	# click
	$("#specify-yard-button").click ->
		swap_warning this, "port"
		manage_elements "yard"
		return false
	# click
	
	is_spamming_flag = false
	$("#port_id_select_tag").change ->
		if is_spamming_flag
			return false
		else
			$.get( "/ships.js?finish=#{$(this).val()}" )
			$(this).attr "disabled" , true
			$("#information-box-ship").hide( "explode", 500 )
			is_spamming_flag = true
			setTimeout =>
				$(this).attr "disabled" , false
				is_spamming_flag = false
				return false
			, 1500 # setTimeout
		# if-else		
		return false
	# change
	return false
# document ready
