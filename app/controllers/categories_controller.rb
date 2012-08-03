class CategoriesController < ApplicationController
  before_filter :filter_regular_users
  def create
  	if params[:category].nil? 
  		flash[:error] = t(:error, :scope => [:controllers, :categories, :create])
  	else
  		parent_id = params[:category][:parent_id]
	  	name = params[:category][:name]
	  	@parent = Category.find_by_id(parent_id) unless parent_id.nil?
	  	@category = (@parent.nil? ? Category.new(:name => name) : @parent.children.new(:name => name))
	  	if @category.save
	  		flash[:success] = t(:success, :scope => [:controllers, :categories, :create])
	  	else
	  		flash[:error] = t(:error, :scope => [:controllers, :categories, :create])
	  	end # if successful save
  	end # if bad params
  	render :nothing => true
  end # create

  def destroy
  	if params[:id].nil?
  		flash[:error] = t(:error, :scope => [:controllers, :categories, :destroy])
  	else
  		Category.find_by_id(params[:id]).destroy
  		flash[:success] = t(:success, :scope => [:controllers, :categories, :destroy])
  	end # if bad params
  	render :nothing => true
  end # destroy
end # CategoriesController
