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
		@asking_bid = @item.bids.find_by_user_id( @item.user.id )
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
		@raw_items ||= Item.where( @terms ) unless @terms.nil? || @terms.empty?
		@raw_items ||= Item.order("created_at DESC").limit(20)
		@raw_items.each do |item|
			(@item_ids ||= []) << item
		end # each item
		@items = Status.where( :item_id => @item_ids, :name => "ready" ).map do |status|
			@raw_items[@raw_items.index{ |r| r.id == status.item_id }]
		end # status
		@categories = Category.roots
		@types = @categories.first.children.map { |x| x.name } unless @categories.empty?
		@title = "Listing Index"
		respond_to do |format|
			format.html
			format.js
		end # respond_to
	end # index
	
	def new
		@title = "New Listing"
		if user_signed_in?
			@item = Item.new
		end # user_signed_in
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
		unless params[:status].nil? || current_user != @item.user	
			p = params[:status]
			user = User.find_by_id(p[:sold_to])
			@item.sold_to user unless user.nil?
			@item.recurring( p[:recurring] ) unless p[:recurring].nil?
		end # no status updates
		redirect_to item_path( @item )
	end # update
	
	def destroy
		@item = Item.find_by_id params[:id]
		@item.destroy
		flash[:success] = t( :success_destroy, :scope => [:controls, :items, :flash] )
		redirect_to root_path
	end # destroy
end # ItemsController
