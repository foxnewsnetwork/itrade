module PagesHelper

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
	
	def form_action_tag( target )
		 content_tag(:button, :class => "btn btn-primary", :type => "submit", :id => "submit-#{target.to_s}-button") do 
			 content_tag(:i, "", :class => "icon-ok icon-white") 
		 end + # submit btn
		 content_tag(:button, :class => "btn btn-inverse", :type => "reset", :name => "reset", :id => "close-#{target.to_s}-button") do 
			 content_tag(:i, "", :class => "icon-remove icon-white")
		 end # reset btn 
	end # form_action_tag
	
end # PagesHelper
