require 'spec_helper'
require 'factories'

describe "UsersGenerals" do
	describe "signing in" do
		describe "from root path" do
			before(:each) do
				@user_data = Factory.next(:user)
				@user = User.create @user_data
				@paths = [items_path, new_item_path, "#login", new_user_registration_path]
				visit root_path
			end # before each
			it "should not missing translations" do
				should_have_translations( html )
			end # it
			(0..3).each do |k|
				it { page.should have_selector( "a", :href => @paths[k] ) }
			end # each type
			[:email, :password].each do |faggot|
				it { page.should have_selector( "input", faggot => "user[#{faggot.to_s}]" ) }
			end # each input
			it "should sign me and take me to my profile" do
				within("#login_user_form") do
					[:email, :password].each do |input|
						fill_in( "login_user_#{input.to_s}", :with => @user_data[input] )
					end # fill_in
					click_on( "Login" )
				end # login user form
				page.should have_content( @user.company )			
			end # 
		end # root path
	end # signing in		
end # UsersGeneral
