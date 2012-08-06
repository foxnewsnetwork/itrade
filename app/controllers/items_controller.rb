class ItemsController < ApplicationController
	def show
		@item = Item.find_by_id( params[:id] )
		if @item.nil?
			render "public/404"
			return
		end # if nil
		@title = "Listing #{@item.title}"
		@elements = @item.elements
		@location = @item.location
		@bids = @item.bids.order( "created_at DESC" )
		if user_signed_in?
			@bid = current_user.bids.new
			@location ||= Location.new
		end
	end # show
	
	def index
		# TODO: show less, paginate, or do something here
		[:category, :type].each do |term|
			(@terms ||= {})[term == :type ? :material_type : term] = params[term] unless params[term].nil?
		end # each term
		@items ||= Item.where( @terms ) unless @terms.nil? || @terms.empty?
		@items ||= Item.order("created_at DESC").limit(20)
		@categories = Category.roots
		@types = @categories.first.children unless @categories.empty?
		@title = "Listing Index"
		respond_to do |format|
			format.html
			format.js
		end # respond_to
	end # index
	
	def new
		if user_signed_in?
			@title = "New Listing"
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
			@title = "Edit listing #{@item.title}"
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
				flash[:success] = t( :success_create, :scope => [:controls, :items, :flash] )
				redirect_to item_path(@item)
			else
				flash[:error] = t( :fail_create, :scope => [:controls, :items, :flash] )
				redirect_to new_item_path
			end # if save
		else
			flash[:notice] = t( :fail_create, :scope => [:controls, :items, :flash] )
			redirect_to new_user_session_path
		end # if signed in
	end # create
	
	def update
		@item = Item.find_by_id( params[:id] )
		if @item.update_attributes( params[:item] )
			flash[:success] = t( :success_update, :scope => [:controls, :items, :flash] )
		else
			flash[:error] = t( :fail_update, :scope => [:controls, :items, :flash] )
		end # if success update
		redirect_to edit_item_path( @item )
	end # update
	
	def destroy
		@item = Item.find_by_id params[:id]
		@item.destroy
		flash[:success] = t( :success_destroy, :scope => [:controls, :items, :flash] )
		redirect_to root_path
	end # destroy
end # ItemsController
