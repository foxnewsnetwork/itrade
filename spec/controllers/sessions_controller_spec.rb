require 'spec_helper'
require 'factories'
describe SessionsController do
	before(:each) do
		@user_data = Factory.next(:user)
		@user = User.create @user_data
		@referer = [items_path, root_path, new_item_path, new_location_path][rand(4)]
	end # before each
	describe "create" do
		before(:each) do 
			@request.env["HTTP_REFERER"] = @referer 
			@request.env["devise.mapping"] = Devise.mappings[:user]
		end # before each
		describe "vanilla" do
			before(:each) do
				post :create, :user => @user_data
			end # before each
			it "should redirect to referer" do
				response.should redirect_to @referer
			end # it
			it "should have the right flash" do
				flash[:success].should_not be_nil
			end # it
		end # vanilla
		describe "ajax" do
			before(:each) do
				xhr :post, :create, :user => @user_data
			end # before each
			it "should render the correct thing" do
				response.should render_template "sessions/create"
			end # it
		end # ajax
	end # create
end # SessionsController
