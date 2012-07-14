class <%= class_name.pluralize %>Controller < ApplicationController
	def create
		@<%= singular_name %> = <%= class_name %>.find_by_id params[:<%= singular_name %>_id]
		if @<%= singular_name %>.nil?
			flash[:error] = t( :fail_<%= singular_name %>_bid_create )
		else
			@<%= singular_name %>.<%= singular_name %>_bid params[:<%= singular_name %>_bid]
			flash[:success] = t( :success_<%= singular_name %>_bid_create )
		end # if
		redirect_to <%= singular_name %>_path @<%= singular_name %>
	end # create
	
	def destroy
		@<%= singular_name %> = <%= class_name %>.find_by_id params[ :<%= singular_name %>_id ]
		@<%= singular_name %>_bid = <%= class_name %>Bid.find_by_id params[ :id ]
		@<%= singular_name %>_bid.destroy
		flash[:success] = t( :success_<%= singular_name %>_bid_destroy )
		redirect_to <%= singular_name %>_path @<%= singular_name %>
	end # destroy
end # <%= class_name.pluralize %>Controller
