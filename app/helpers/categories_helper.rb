module CategoriesHelper

	# the first one ALWAYS hits category.roots
	def category_select_tag( names, options = nil )
		output = { :html => "", :js => "" }
		previous_name = ""
		names.each do |name|
			output[:html] += select_tag( name, "", :id => "select-#{name}", :name => name )
			if name == names.first
				output[:js] += %Q(
					$(document).ready( function() { 
						var getchildcats = function(id, target) { 
							$.get( '#{categories_path}/' + id + '.json', function(data) { 
									var output = '';
									var cats = data['children'];
									for( var k = 0; k < cats.length; k++ ) { 
										var i = cats[k];
										output += '<option value=\\'';
										output += i['name'];
										output += '\\' title=\\'';
										output += i['id']
										output += '\' id=\'cat-option-';
										output += i['name'];
										output += '\'>'
										output += i['name'];
										output += '</option>';
									} // for k
									$(target).html(output);
								} ); // get children
						}; // getchildcats
						var getchildcats2 = function(id, target) { 
							$.get( '#{categories_path}/' + id + '.json', function(data) { 
									var output = '';
									var cats = data['children'];
									for( var k = 0; k < cats.length; k++ ) { 
										var i = cats[k];
										output += '<option value=\'';
										output += i['name'];
										output += '\' title=\'';
										output += i['id']
										output += '\' id=\'cat-option-';
										output += i['name'];
										output += '\'>'
										output += i['name'];
										output += '</option>';
									} // for k
									$(target).html(output);
									<% unless name == names.last %>
										!!NIGGERFUCKBITCHWHORESLUTINJECTHERECOCKSUCKER!!
									<% end # unless last name %>
								} ); // get children
						}; // getchildcats2
						$.get( '#{categories_path}.json', function(data) { 
							var cats = data['categories'];
							var output = '';
							for( var k = 0; k < cats.length; k++ ) { 
								var i = cats[k];
								// output += "<option value='" + i['name'] + "' title='" + i['id'] + "' id='cat-option-" + i['name'] + "'>" + i['name'] + "</option>";
								output += '<option value=\'';
								output += i['name'];
								output += '\' title=\'';
								output += i['id']
								output += '\' id=\'cat-option-';
								output += i['name'];
								output += '\'>'
								output += i['name'];
								output += '</option>';
							} // for k
							$('#select-#{name}').html(output);
							<% unless name == names.last %>
								!!NIGGERFUCKBITCHWHORESLUTINJECTHERECOCKSUCKER!!
							<% end # unless last name %>
						} ); // get
					} ); // document.ready
				) # output[:js]
			else
				output[:js] = output[:js].gsub(/!!NIGGERFUCKBITCHWHORESLUTINJECTHERECOCKSUCKER!!/, %Q(
					getchildcats(cats[0]['id'], '#select-#{name}' );
					$("#select-#{previous_name}").click( function() { 
						var id = $("#cat-option-" + $(this).val()).attr("title");
						getchildcats2(id, '#select-#{name}');				
					} ); // click callback
				) ) # output[:js]
			end # if first name
			previous_name = name
		end # each name
		content_tag(:div, options) do
			output[:html]
		end + # content_tag
		content_tag(:script, :type => "text/javascript") do
			output[:js]
		end # script_tag
	end # category_select_tag
end # CategoriesHelper
