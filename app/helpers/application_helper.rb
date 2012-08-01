module ApplicationHelper
	def title
		"Tracago!" if @title.nil?
		"Tracago - #{@title}" unless @title.nil?
	end # title
end # ApplicationHelper
