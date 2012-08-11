class LocationsController < ApplicationController
  before_filter :filter_anonymous_users, :only => [:create, :destroy, :update]
  before_filter :p_getitems, :only => [:create, :destroy, :update]
  
  def index
  	@locations = Location.where( :official => true ) 
  	respond_to do |format|
  		format.json { render "index", :hander => "json_builder" }
  	end # respond_to
  end # index

	
	def update
		if current_user == @item.user
			@location = Location.find_by_id params[:id]
			if @location.nil?
				render "public/404"
				return
			end # if bad location
			if @location.update_attributes( params[:location] )
				flash[:success] = t(:success_location_update)
			else
				flash[:error] = t(:fail_location_update)
			end # if success update
		else
			flash[:error] = t(:fail_location_update)
		end # if correct_user
		redirect_to @item
	end # update
	
  def create
  	if current_user == @item.user
  		@location = @item.location.destroy unless @item.location.nil?
			@location = Location.create params[:location]
			@item.at @location unless @location.nil?
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
  		@item.location.destroy unless @item.location.nil?
  		@item.location_id = nil
  		@item.save
  		flash[:success] = t(:success_location_destroy)
  	else # if correct user
  		flash[:error] = t(:fail_location_destroy)
  	end # else incorrect user
  	redirect_to @item
  end # destroy
  
  private
  	def p_getitems
  		@item ||= Item.find_by_id params[:item_id]
			@item ||= Bid.find_by_id params[:bid_id]
			@item ||= User.find_by_id params[:user_id]
			if @item.nil?
				render "public/404" 
				return
			end
  	end # p_getitems
end # LocationsController
