class ItemsController < ApplicationController
	def show
		@item = Item.find_by_id( params[:id] )
		
		render "public/404" if @item.nil?
		@elements = @item.elements
	end # show
	
	def index
		# TODO: show less, paginate, or do something here
		@items = Item.all
	end # index
	
	def new
		if user_signed_in?
			@item = Item.new
		else
			redirect_to new_user_session_path
			flash[:notice] = t( :fail_item_new )
		end # if signed in 
	end # new
	
	def edit
		if user_signed_in?
			@item = Item.find_by_id( params[:id] )	
			render "public/404" if @item.nil?
			unless current_user == @item.user
				flash[:notice] = t( :fail_item_edit )
				redirect_to item_path @item
			end # unless correct user
		else
			flash[:notice] = t( :fail_item_edit )
			redirect_to new_user_session_path
		end # if signed in
	end # edit
	
	def create
		if user_signed_in?
			@item = current_user.items.new( params[:item] )	
			if @item.save
				flash[:success] = t( :success_item_create )
				redirect_to item_path(@item)
			else
				flash[:error] = t( :fail_item_create )
				redirect_to new_item_path
			end # if save
		else
			flash[:notice] = t( :fail_item_create )
			redirect_to new_user_session_path
		end # if signed in
	end # create
	
	def update
		@item = Item.find_by_id( params[:id] )
		if @item.update_attributes( params[:item] )
			flash[:success] = t( :success_item_update )
		else
			flash[:error] = t( :fail_item_update )
		end # if success update
		redirect_to edit_item_path( @item )
	end # update
	
	def destroy
		@item = Item.find_by_id params[:id]
		@item.destroy
		flash[:success] = t( :success_item_destroy )
		redirect_to root_path
	end # destroy
end # ItemsController
