require 'spec_helper'
require 'factories'
describe "ItemCreations" do
  describe "logged in" do
  	before(:each) do
  		@user_data = Factory.next(:user)
  		@user = User.create @user_data
  	end # before each
  	before(:each) do
  		@steps = [
  			lambda { visit root_path } ,
  			lambda do 
  				fill_in( "login_user_email", :with => @user_data[:email] )
  				fill_in( "login_user_password", :with => @user_data[:password] )
  				click_on( "Login" )
  			end ,
  			lambda { click_link( "header_link_sell" ) } ,
  			lambda do
  				fill_in( "item[title]", :with => "Crack cocain" )
  				fill_in( "item[description]", :with => "hilarious rocks for destroy lives")
  				fill_in( "item[material]", :with => "in 12 gaylord boxes")
  				fill_in( "item[quantity]", :with => "2340820384")
  				click_on( "item[submit]" )
  			end
  		] # steps
  	end # before each
  	(0..3).each do |k|
  		it "should have proper translations" do
  			(0..k).each do |j|
  				@steps[j].call
  			end # each j
  			should_have_translations(page.html)
  		end # it
  	end # each k
  	it "should create a new item" do
  		expect do
  			(0..3).each do |k|
  				@steps[k].call
  			end # each k
  		end.to change(Item, :count).by(1)
  	end # it
  	
  end # logged in
end # ItemsCreation
