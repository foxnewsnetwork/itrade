require 'spec_helper'
require 'factories'
describe PagesController do

  describe "GET 'home'" do
    it "returns http success" do
      get "about"
      response.should be_success
    end # it
  end # Get Home
  
  describe "Get 'admin'" do
  	describe "logged in" do
  		login_admin
  		it "should return success" do
  			get "admin"
  			@current_user.admin.should be_true
  			# pending "this test should have passed but isn't passing for some reason"
  			response.should be_success
  		end # it
  	end # logged in
  	[lambda { login_user }, lambda { 0 }].each do |operation|
			describe "otherwise" do
				subject { response }
				operation.call
				before(:each) { get "admin" }
				it "should redirect to root" do
					should redirect_to root_path
				end # it
				it "should have flash" do
					flash[:error].should_not be_nil
				end # it
			end # otherwise
		end # each operation
  end # get admin
end # PagesController
