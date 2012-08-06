class CategoriesController < ApplicationController
  before_filter :filter_regular_users, :only => [:create, :destroy]
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
  	respond_to do |format|
  		format.js
  		format.html { render :nothing => true }
  	end # respond_to
  end # create

  def destroy
  	if params[:id].nil?
  		flash[:error] = t(:error, :scope => [:controllers, :categories, :destroy])
  	else
  		@category = Category.find_by_id(params[:id]).destroy
  		flash[:success] = t(:success, :scope => [:controllers, :categories, :destroy])
  	end # if bad params
  	respond_to do |format|
  		format.js
  		format.html { render :nothing => true }
  	end # respond_to
  end # destroy
  
  def show
  	@category = Category.find_by_id(params[:id])
  	if @category.nil?
  		render "public/404"
  		return
  	end # if nil
  	@children = @category.children
  	respond_to do |format|
  		format.js
  		format.json { render "show", :handler => [:json_builder] }
  	end # respond_to
  end # show
  
  def index
  	@categories = Category.roots
  	respond_to do |format|
  		format.js
  		format.html { render :nothing => true }
  		format.json { render "index", :handler => [:json_builder] }
  	end # respond_to
  end # index
end # CategoriesController
