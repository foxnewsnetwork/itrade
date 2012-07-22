class BidsController < ApplicationController
	def show
		@bid = Bid.find_by_id params[:id]
		if @bid.nil?
			render "public/404" 
		else # if bid
			redirect_to @bid.item 
		end # else bid
	end # show

	def create
		if user_signed_in?
			current_user.bid params[:bid], params[:item_id]
			flash[:success] = t( :success_bid_create )
			redirect_to item_path params[:item_id]
		else
			flash[:notice] = t( :fail_bid_create )
			redirect_to new_user_session_path
		end # if user_signed_in?
		
	end # create
	
	def destroy
		if user_signed_in?
			@item = Item.find_by_id params[ :item_id ]
			@bid = Bid.find_by_id params[ :id ]
			if current_user == @bid.user
				@bid.destroy
				flash[:success] = t( :success_bid_destroy )
			else
				flash[:error] = t( :fail_bid_destroy )
			end # if correct user
			redirect_to item_path @item
		else
			flash[:error] = t( :fail_bid_destroy )
			redirect_to new_user_session_path
		end # if signed in
	end # destroy
end # BidsController
