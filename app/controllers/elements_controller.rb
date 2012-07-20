class ElementsController < ApplicationController
  before_filter :filter_anonymous_users, :only => [:create, :destroy]
  
  def create
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
  end # create

  def destroy
		@item = current_user.items.find_by_id params[:item_id]
		unless @item.nil?
			@element = @item.elements.find_by_id params[:id]
			unless @element.nil?
				@element.destroy
				flash[:success] = t( :success_element_destroy )
			else # if nil
				flash[:error] = t( :fail_element_destroy )
			end # else nil
		else # if correct user
			flash[:error] = t(:fail_element_destroy)
		end # else correct user
		respond_to do |format|
			format.js
			format.html { redirect_to item_path params[:item_id] }
		end # respond_to
  end # Destroy
  
end # ElementsController
