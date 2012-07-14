class ItemsController < ApplicationController
	def show
		@item = Item.find_by_id( params[:id] )
	end # show
	
	def index
		# TODO: show less, paginate, or do something here
		@items = Item.all
	end # index
	
	def new
		@item = Item.new
	end # new
	
	def edit
		@item = Item.find_by_id( params[:id] )
	end # edit
	
	def create
		@item = Item.new( params[:item] )
		# TODO: i18n this junk!
		if @item.save
			flash[:success] = t( :success_item_create )
			redirect_to item_path(@item)
		else
			flash[:error] = t( :fail_item_create )
			redirect_to new_item_path
		end # if save
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
