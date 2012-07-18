class ElementsController < ApplicationController
  def create
  	if user_signed_in?
  		@item = Item.find_by_id( params[:item_id] )
  		if @item.user == current_user
  			@element = @item.elements.new params[:element]
  			if @element.save
  				flash[:success] = t( :success_element_create )
  			else
  				flash[:error] = t( :fail_element_create )
  			end # if success save
  			redirect_to item_path @item
  		else
  			flash[:notice] = t( :fail_element_create )
  			redirect_to item_path @item
  		end # if correct user
  	else
  		flash[:notice] = t(:fail_element_create)
  		redirect_to new_user_session_path
  	end # if signed in
  end # create

  def destroy
  	if user_signed_in?
  		@item = current_user.items.find_by_id params[:item_id]
  		unless @item.nil?
  			@element = @item.elements.find_by_id params[:id]
  			unless @element.nil?
  				@element.destroy
  				flash[:success] = t( :success_element_destroy )
  			else # if nil
  				flash[:error] = t( :fail_element_destroy )
  			end # else nil
  			redirect_to item_path @item
  		else # if correct user
  			flash[:error] = t(:fail_element_destroy)
  			redirect_to item_path params[:item_id]
  		end # else correct user
  	else # if signed in
  		flash[:notice] = t(:fail_element_destroy)
  		redirect_to new_user_session_path
  	end # else signed in
  end # Destroy
end # ElementsController
