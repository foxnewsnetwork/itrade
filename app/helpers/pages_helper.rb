module PagesHelper


	# money input tag, be sure to specify the money options
	def money_field_tag(f, label, options = { :money => "$" })
		content_tag(:div, :class => "input-prepend") do
			content_tag(:span, options[:money], :class => "add-on") +
			f.number_field( label, options )
		end # div tag
	end # money_field_tag
	
	# type is :button, :div, etc.
	def collapse_tag(type, content = "", options = {}, &block)
		thenumbers = rand(999999999)
		link_to( "#collapse-num-#{thenumbers}" ) do
			content_tag( type, content, options.merge(:id => "collapse-button-num-#{thenumbers}") )		
		end + # content_tag
		content_tag( :div, :id => "collapse-num-#{thenumbers}" ) { yield } +
		content_tag( :script, :type => "text/javascript" ) do
			%Q(
				$(function() { 
					$('#collapse-button-num-#{thenumbers}').collapse({ 'toggle' : true });
					$('#collapse-num-#{thenumbers}').collapse('toggle');
					$('#collapse-button-num-#{thenumbers}').click(function() { 
						$('#collapse-num-#{thenumbers}').collapse('toggle');
					} ); // click
				} ); // document.ready
			) # javascript
		end # script_tag
	end # collapse_tag	
	
	# options = { :open => id, :close => id, other stuff }
	def dialog_tag(id, options, &block)
		content_tag(:div, options.merge( :id => id ) ) { yield } +
		content_tag(:script, :type => "text/javascript") do
			%Q(
				$(function() { 
					$('##{id}').dialog( { autoOpen: false,	show: 'explode', hide: 'explode' } );
					$('##{options[:open]}' ).click(function(){ 
						$('##{id}').dialog('open');
						return false;
					} ); // open callback
					$('##{options[:close]}' ).click(function(){ 
						$('##{id}').dialog('close');
					} ); // open callback
				} ); // document.ready 
			) # javascript
		end # content_tag
	end # dialog_tag
	
	# id is the id of form!!
	def ajax_submit_tag(id, options, &block )
		content_tag(:button, options.merge(:type => "submit", :id => id + "_submit") ) { yield } +
		content_tag(:script, :type => "text/javascript") do
			%Q(
				$( function() { 
					$('##{id}_submit').tooltip( { title : '...', trigger : 'manual' } ).click( function(e) { 
						$(this).tooltip( 'show' );
						$(this).attr('disabled', true);
						setTimeout( function() { 
							$('##{id}_submit').attr('disabled', false);
							$('##{id}_submit').tooltip( 'hide' );
						}, 1500 ); // setTimeout
						$('##{id}').submit();
						$('##{id}')[0].reset();
						return false;
					} ); // click callback
				} ); //  document.ready
			) # javascript
		end # content_Tag
	end # ajax_content_tag
	
	def stateful_button_tag(id, options = {}, &block )
		content_tag(:button, options.merge(:id => id) ) { yield } +
		content_tag(:script, :type => "text/javascript") do
			%Q(
				$( function() { 
					$('##{id}').tooltip( { title : '...', trigger : 'manual' } ).click( function(e) { 
						$(this).tooltip( 'show' );
						$(this).attr('disabled', true);
						setTimeout( function() { 
							$('##{id}').attr('disabled', false);
							$('##{id}').tooltip( 'hide' );
						}, 1500 ); // setTimeout
						return false;
					} ); // click callback
				} ); //  document.ready
			) # javascript
		end # content_Tag
	end # stateful_button_tag
	
	def form_action_tag( target )
		 form_submit_tag(target) + form_reset_tag(target)
	end # form_action_tag
	
	def form_submit_tag( target )
		content_tag(:button, :class => "btn btn-primary", :type => "submit", :id => "submit-#{target.to_s}-button") do 
			 content_tag(:i, "", :class => "icon-ok icon-white") 
		 end
	end # form_submit_tag
	def form_reset_tag(target)
		 content_tag(:button, :class => "btn btn-inverse", :type => "reset", :name => "reset", :id => "close-#{target.to_s}-button") do 
			 content_tag(:i, "", :class => "icon-remove icon-white")
		 end # reset btn 
	end # form_reset_tag
	
	# setups = { :uri => String, :key => String, :value => String, :default => [String] }
	def remote_select_tag(name, setups = {}, options = {} )
		defaults = { 
			:uri => "/" + name[ /^\w+/ ].pluralize + ".json" ,
			:name => name[ /\[\w+\]/ ].gsub( /(\[|\])/, "") ,
			:key => "name" ,
			:value => "id" ,
			:default => []
		}.merge setups # defaults
		select_tag( name, options_for_select(defaults[:default]), options.merge( :id => "remote_select_#{name}" ) ) +
		content_tag(:script, :type => "text/javascript") do
			%Q(
				$(function() { 
					$.get('#{defaults[:uri]}', function(data) { 
						var temp = data['#{default[:default]}'];
						$('#remote_select_#{name}').html(options_for_select(temp['#{defaults[:key]}'], temp['#{defaults[:value]}']));
					} ); // get
				} ); // document.ready
			) # Jq String
		end # content_tag
	end # remote_select_tag
end # PagesHelper
