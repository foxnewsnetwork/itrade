class <%= class_name.pluralize %>Controller < ApplicationController
	def show
		@<%= plural_name.singularize %> = <%= plural_name.singularize %>.find_by_id( params[:id] )
	end # show
	
	def index
		# TODO: show less, paginate, or do something here
		@<%= plural_name %> = <%= plural_name.singularize %>.all
	end # index
	
	def new
		@<%= plural_name.singularize %> = <%= plural_name.singularize %>.new
	end # new
	
	def edit
		@<%= plural_name.singularize %> = <%= plural_name.singularize %>.find_by_id( params[:id] )
	end # edit
	
	def create
		@<%= plural_name.singularize %> = <%= plural_name.singularize %>.new( params[:<%= plural_name.singularize %>] )
		# TODO: i18n this junk!
		if @<%= plural_name.singularize %>.save
			flash[:success] = t( :success_<%= plural_name.singularize %>_create )
			redirect_to item_path(@<%= plural_name.singularize %>)
		else
			flash[:error] = t( :fail_<%= plural_name.singularize %>_create )
			redirect_to new_<%= plural_name.singularize %>_path
		end # if save
	end # create
	
	def update
		@<%= plural_name.singularize %> = <%= plural_name.singularize %>.find_by_id( params[:id] )
		if @<%= plural_name.singularize %>.update_attributes( params[:<%= plural_name.singularize %>] )
			flash[:success] = t( :success_<%= plural_name.singularize %>_update )
		else
			flash[:error] = t( :fail_<%= plural_name.singularize %>_update )
		end # if success update
		redirect_to edit_<%= plural_name.singularize %>_path( @<%= plural_name.singularize %> )
	end # update
	
	def destroy
		@<%= plural_name.singularize %> = <%= plural_name.singularize %>.find_by_id params[:id]
		@<%= plural_name.singularize %>.destroy
		flash[:success] = t( :success_<%= plural_name.singularize %>_destroy )
		redirect_to root_path
	end # destroy
end # <%= plural_name %>Controller
