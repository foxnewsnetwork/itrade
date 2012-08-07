class UsersController < ApplicationController
  before_filter :filter_anonymous_users, :only => [:destroy, :update, :edit]
  before_filter :filter_wrong_users, :only => [:show]
  
  def show
  	@user = User.find_by_id( params[:id] )
  	if @user.nil?
  		render "public/404"
  		return
  	end # if nil
  	@title = @user.company
  	@items = @user.items
  	@location = @user.location
  	@location ||= Location.new
  end # show

  def index
  	@title = "User Index"
  	@users = User.all
  end # index

  def new
  	if user_signed_in?
  		flash[:notice] = t( :failed_user_new )
  		redirect_to user_path current_user
  	else
  		@title = "New User"
  		@user = User.new	
  	end # user_signed_in
  end # new

  def edit
		@user = User.find_by_id( params[:id] )
		@title = "Edit #{@user.company}"
		unless current_user.id == @user.id
			flash[:notice] = t( :failed_user_edit )
			redirect_to user_path @user
		end # unless correct user
  end # edit
  
  def create
  	@user = User.new params[:user]
  	if @user.save
  		flash[:success] = t( :success_user_create )
  		redirect_to user_path @user
  	else
  		flash[:failure] = t( :fail_user_create )
  		redirect_to new_user_path
  	end # if save
  end # create
  
  def destroy
		@user = User.find_by_id params[:id]
		if @user == current_user
			@user.destroy
			flash[:success] = t( :success_user_destroy )
			redirect_to root_path
		else
			flash[:error] = t( :fail_user_destroy )
			redirect_to user_path @user
		end # if correct user
  end # destory	
  
  def update
  	@user = User.find_by_id params[:id]
  	if @user == current_user
  		if @user.update_attributes params[:user]
  			flash[:success] = t(:success_user_update)
  		else # else fail update
  			flash[:error] = t(:fail_user_update)
  		end # else success update
  	else # if right user
  		flash[:error] = t(:fail_user_update)
  	end # else wrong user
  	redirect_to @user
  end # update
end # UsersController
