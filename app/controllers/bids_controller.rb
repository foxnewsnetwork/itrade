class BidsController < ApplicationController
	before_filter :filter_anonymous_users, :only => [:new, :create, :destroy]
	def show
		@bid = Bid.find_by_id params[:id]
		if @bid.nil?
			render "public/404" 
			return
		end # no bid
		@item = @bid.item
		@location = @bid.location
		@location ||= Location.new
		@bids = @item.bids
	end # show
	
	def new
		@item = Item.find_by_id params[:item_id]
		@bids = @item.bids
		@bid = current_user.bids.new
		render "public/404" if @item.nil?
	end # new
	
	def edit
	
	end # edit

	def create
		@bid = current_user.bid params[:bid], params[:item_id]
		@location = Location.create params[:location] unless params[:location].nil?
		@bid.at @location unless @location.nil?
		flash[:success] = t( :success_bid_create )
		redirect_to item_path params[:item_id]
	end # create
	
	def destroy
		@item = Item.find_by_id params[ :item_id ]
		@bid = Bid.find_by_id params[ :id ]
		if current_user == @bid.user
			@bid.destroy
			flash[:success] = t( :success_bid_destroy )
		else
			flash[:error] = t( :fail_bid_destroy )
		end # if correct user
		redirect_to item_path @item
	end # destroy
	
	def update
		@bid = Bid.find_by_id params[:id]
		if @bid.nil?
			render "public/404"
		end # if no bid
		@item = Item.find_by_id params[:item_id]
		if current_user == @bid.user
			unless params[:location].nil?
				if @bid.location.nil?
					@bid.at Location.create( params[:location] )
				else
					@bid.location.update_attributes params[:location]
				end # if no location
				flash[:error] = t(:fail_location_create, :scope => [:controller, :bids, :update] ) if @bid.location.nil?
			end # unless no location params
			unless params[:bid].nil?
				if @bid.update_attributes params[:bid]
					flash[:success] = t(:success_bid_update)
				else
					flash[:error] = t(:fail_bid_update)
				end # if success update
			end # unless no bid params
		else
			flash[:error] = t(:fail_bid_update)
		end # if correct user
		redirect_to [@item, @bid]
	end # update
end # BidsController
