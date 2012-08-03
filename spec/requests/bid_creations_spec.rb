require 'spec_helper'
require 'factories'
describe "BidCreations" do
	before(:each) do
		@user_data = Factory.next(:user)
		@user = User.create @user_data
		@item = Factory(:item, :user => @user)
		@login = lambda do |user|
			visit new_user_session_path
			fill_in( "login_user_email", :with => user[:email] )
			fill_in( "login_user_password", :with => user[:password] )
			click_on( "submit-login-button" )
		end # login_user
	end # before each
	describe "owner" do
		before(:each) do
			@login.call @user_data
			visit item_path( @item )
			fill_in( "bid_offer", :with => 234234 )
			select( "CNF", :from => "location_shipping" )
			fill_in( "location[name]", :with => "Long Beach Port" )
			fill_in( "location_address", :with => "1234 Fake Street" )
			fill_in( "location_city", :with => "Los Angeles" )
			fill_in( "location_state", :with => "California" )
			fill_in( "location_zip", :with => "90210" )
			fill_in( "location_country", :with => "USA" )
			click_on( "submit-bid-button" )
		end # before each
		it { should_have_translations( page.html ) }
		it "should show the bid" do
			page.should have_content( 234234 )
		end # it
	end # owner
end # BidCreation
