class LocationsController < ApplicationController
  before_filter :filter_anonymous_users, :only => [:create, :destroy]
  before_filter :p_getitems, :only => [:create, :destroy]
  
  def search
  end

  def create
  	if current_user == @item.user
			@location = Location.create params[:location]
			@item.at @location
			if @item.location.nil?
				flash[:error] = t(:fail_location_create)	
			else
				flash[:success] = t(:success_location_create)	
			end # if couldn't assign locaiton
		else # if correct_user

  		flash[:error] = t(:fail_location_create)	
  	end # else wrong user
  	redirect_to @item
  end # create

  def destroy
  	if current_user == @item.user
  		@item.location_id = nil
  		@item.save
  		flash[:success] = t(:success_location_destroy)
  	else # if correct user
  		flash[:notice] = t(:fail_location_destroy)
  	end # else incorrect user
  	redirect_to @item
  end # destroy
  
  private
  	def p_getitems
  		@item ||= Item.find_by_id params[:item_id]
			@item ||= Bid.find_by_id params[:bid_id]
			@item ||= User.find_by_id params[:user_id]
			render "public/404" if @item.nil?
  	end # p_getitems
end # LocationsController
