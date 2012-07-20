class UsersController < ApplicationController
  def show
  	@user = User.find_by_id( params[:id] )
  	if @user.nil?
  		render "public/404"
  		return
  	end # if nil
  end # show

  def index
  	@users = User.all
  end # index

  def new
  	if user_signed_in?
  		flash[:notice] = t( :failed_user_new )
  		redirect_to user_path current_user
  	else
  		@user = User.new	
  	end # user_signed_in
  end # new

  def edit
  	if user_signed_in?
  		@user = User.find_by_id( params[:id] )
  		unless current_user.id == @user.id
  			flash[:notice] = t( :failed_user_edit )
  			redirect_to user_path @user
  		end # unless correct user
  	else
  		flash[:notice] = t( :failed_user_edit )
  		redirect_to new_user_session_path
  	end # if exists user
  	
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
  	if user_signed_in?
  		@user = User.find_by_id params[:id]
  		if @user == current_user
  			@user.destroy
  			flash[:success] = t( :success_user_destroy )
  			redirect_to root_path
  		else
  			flash[:error] = t( :fail_user_destroy )
  			redirect_to user_path @user
  		end # if correct user
  	else
  		flash[:error] = t( :fail_user_destroy )
  		redirect_to new_user_session_path
  	end # if exist user
  end # destory	
end # UsersController
