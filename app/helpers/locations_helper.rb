module LocationsHelper
	
	def location_field_tag(name, options={})
		text_field_tag( name, "", options.merge(:id => "location-select-tag") ) +
		content_tag(:script, :type=>"text/javascript") do 
			%Q(
				$( function() { 
					$.get('#{locations_path}.json', function(data) { 
						var autoOptions = ['faggot','nigger','test'];
						for( var k in data['locations'] ) { 
							var locations = data['locations'];
							autoOptions.push( locations[k]['name'] );
						} // for k
						$('#location-select-tag').autocomplete( { source : autoOptions } );
					} ); // get json
				} ); // function
			) # js output
		end # script tag
	end # location_select_tag
end # LocationHelper
