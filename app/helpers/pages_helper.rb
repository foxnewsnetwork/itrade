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
			)
		end # content_tag
	end # dialog_tag
	
	def form_action_tag( target )
		 content_tag(:button, :class => "btn btn-primary", :type => "submit", :id => "submit-#{target.to_s}-button") do 
			 content_tag(:i, "", :class => "icon-ok icon-white") 
		 end + # submit btn
		 content_tag(:button, :class => "btn btn-inverse", :type => "reset", :name => "reset", :id => "close-#{target.to_s}-button") do 
			 content_tag(:i, "", :class => "icon-remove icon-white")
		 end # reset btn 
	end # form_action_tag
	
end # PagesHelper
