class LocationsController < ApplicationController
  before_filter :filter_anonymous_users, :only => [:create, :destroy]
  
  def search
  end

  def create
  	@item = Item.find_by_id params[:item_id]
  	if current_user == @item.user
			@location = Location.create params[:location]

			@item.location_id = @location.id

			@item.save!
			if @item.location.nil?
				flash[:error] = t(:fail_location_create)	
			else
				flash[:success] = t(:success_location_create)	
			end # if couldn't assign locaiton
		else # if correct_user

  		flash[:error] = t(:fail_location_create)	
  	end # else wrong user
  	redirect_to item_path params[:item_id]
  end # create

  def destroy
  	@item = Item.find_by_id params[:item_id]
  	if current_user == @item.user
  		@item.location_id = nil
  		@item.save
  		flash[:success] = t(:success_location_destroy)
  	else # if correct user
  		flash[:notice] = t(:fail_location_destroy)
  	end # else incorrect user
  	redirect_to item_path params[:item_id]
  end # destroy
end # LocationsController
