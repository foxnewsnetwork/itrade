# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ ->
	start_id = $("#item-metadata").attr "data_id"
	start_type = $("#item-metadata").attr "data_type"
	
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
			$("#request_best_routes_button").hide()
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
			port_id = $(this).val()
			port_domestic = $("#port-metadata-#{port_id}").attr "data_domestic"
			if port_domestic == true || port_domestic == "true"
				target_uri = "/trucks.js?"
				fgen = (nig) ->
					(p) ->
						target_uri += encodeURIComponent( "#{nig}[#{p[0]}]" ) + "=#{p[1]}&"	
					# p
				# fgen
				fgen("f")(clusterfuck) for clusterfuck in [ ['id', port_id], ['type', 'port'] ]
				fgen("s")(clusterfuck) for clusterfuck in [ ['id', start_id], ['type', start_type] ]
				
				$.get( target_uri )
				$("#information-box-truck").hide( "explode", 500 )
				$("#request_best_routes_button").hide()
			else
				$.get( "/ships.js?finish=#{port_id}" )	
				$("#information-box-ship").hide( "explode", 500 )
				$("#request_best_routes_button").show()
			# if-else
			
			$(this).attr "disabled" , true
			
			is_spamming_flag = true
			setTimeout =>
				$(this).attr "disabled" , false
				is_spamming_flag = false
				return false
			, 1500 # setTimeout
		# if-else		
		return false
	# change
	
	yard_change_request = =>
		yard_data = {}
		data_ready_flag = true
		((f) ->
			yard_data[f] = $("#yard_#{f}").val()
			if !yard_data[f]? || yard_data[f] == ""
				data_ready_flag = false
		)(fucker) for fucker in ['street_address','city','state','zip']
		
		if data_ready_flag
			qstring = "/trucks.js?"
			((key,val) ->
				qstring += encodeURIComponent( key ) + "=#{val}&"
				return false
			)(key, val) for key, val of { "f[type]" : "yard" , "f[city]" : yard_data['city'], "s[type]" : start_type, "s[id]" : start_id }
			$.get( qstring )
			return true
		return false
		# if data_ready_flag			
	# yard_change_request
	
	$("#yard_city").change ->
		yard_change_request()
		return false
	# change
	
	$("#request_best_routes_button").click ->
		location_type = $("#location_type_id").attr "value"
		if location_type == 'port'
			port_id = $("#port_id_select_tag").val()
			port_domestic = $("#port-metadata-#{port_id}").attr "data_domestic"
			if port_domestic == true || port_domestic == "true"
				alert "this service isn't availble"
			else
				qstring = "/targets.js?"
				((key,val) ->
					qstring += encodeURIComponent( key ) + "=#{val}&"
					return false
				)(key, val) for key, val of { "yard_id" : start_id , "port_id" : port_id }
				$.get qstring 
			# if domestic
		else if location_type == 'yard'
			yard_data = {}
			data_ready_flag = true
			((f) ->
				yard_data[f] = $("#yard_#{f}").val()
				if !yard_data[f]? || yard_data[f] == ""
					data_ready_flag = false
			)(fucker) for fucker in ['street_address','city','state','zip']
			alert "this service isn't availble"
		else
			# Catch Error Here
		# if-elseif-else
		return false
	return false
# document ready
