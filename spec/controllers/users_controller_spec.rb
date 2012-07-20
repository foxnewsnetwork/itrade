require 'spec_helper'
require 'factories'

describe UsersController do
	describe "GET section" do
		before(:each) do
			@user = User.create Factory.next(:user)
		end # before
		it "should be success" do
			get "show", :id => @user
			response.should be_success
		end # it
		it "should show a 404 page" do
			get "show", :id => 23042034230492
			response.should render_template "public/404"
		end # it
		it "should be success" do
			get "index"
			response.should be_success
		end # it
		it "should be succes" do
			get "new"
			response.should be_success
		end # it
		it "should redirect and show flash" do
			get "edit", :id => @user
			response.should redirect_to new_user_session_path
			flash[:notice].should_not be_nil
		end # it
		describe "when signed in" do
			login_user
			it "should redirect and show flash" do
				get "new"
				response.should redirect_to user_path( @current_user )
				flash[:notice].should_not be_nil
			end # it
			it "should be success" do
				get "edit", :id => @current_user
				response.should be_success
			end # it
			it "should redirect and show flash" do
				get "edit", :id => @user
				response.should redirect_to user_path @user
				flash[:notice].should_not be_nil
			end # it
		end # when signed in
	end # GET section
	describe "POST section" do
		before(:each) do
			@user = Factory.next(:user)
		end # before
		it "should allow for a new user creation" do
			lambda do
				post :create, :user => @user
			end.should change(User, :count).by(1)
		end # it
		it "should redirect to the user show page and have a flash message" do
			post :create, :user => @user
			user = assigns(:user)
			response.should redirect_to user_path(user)
			flash[:success].should_not be_nil
		end # it
	end # Post section
	describe "Delete seciont" do
		before(:each) do
			@user = User.create Factory.next(:user)
		end # before each
		describe "success" do
			login_user
			it "should not give the power to kill indescriminately" do
				lambda do
					delete :destroy, :id => @user
				end.should_not change(User, :count)
			end # it
			it "should let the user know he can't be killing indescriminately" do
				delete :destroy, :id => @user
				flash[:error].should_not be_nil
			end # it
			it "should kill the current user" do
				delete :destroy, :id => @current_user
				User.find_by_id( @current_user ).should be_nil
				flash[:success].should_not be_nil
			end # it
			it "should only kill 1 user" do
				lambda do
					delete :destroy, :id => @current_user
				end.should change(User, :count).by(-1)
			end # it
		end # succuess
		describe "failure" do
			it "should not kill anything" do
				lambda do
					delete :destroy, :id => @user
				end.should_not change(User, :count)
			end # it
			it "should display a flash message" do
				delete :destroy, :id => @user
				flash[:error].should_not be_nil
			end # it
		end # failure
	end # delete
end # UsersController
