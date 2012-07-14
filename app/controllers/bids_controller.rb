class BidsController < ApplicationController
	def create
		@item = Item.find_by_id params[:item_id]
		if @item.nil?
			flash[:error] = t( :fail_bid_create )
		else
			@item.bid params[:bid]
			flash[:success] = t( :success_bid_create )
		end # if
		redirect_to item_path @item
	end # create
	
	def destroy
		@item = Item.find_by_id params[ :item_id ]
		@bid = Bid.find_by_id params[ :id ]
		@bid.destroy
		flash[:success] = t( :success_bid_destroy )
		redirect_to item_path @item
	end # destroy
end # BidsController
