require 'spec_helper'
require 'factories'

describe "UsersGenerals" do
	describe "signing in" do
		describe "from root path" do
			before(:each) do
				@user_data = Factory.next(:user)
				@user = User.create @user_data
				visit root_path
			end # before each
			it "should not be missing translations" do
				page.should_not have_selector( "span", :class => "translation_missing" )
			end # it
			[:buy, :sell, :signin, :signup].each do |type|
				it { page.should have_selector( "a", :text => type.to_s.capitalize ) }
			end # each type
			[:email, :password].each do |faggot|
				it { page.should have_selector( "input", faggot => "user[#{faggot.to_s}]" ) }
			end # each input
			it "should sign me and take me to my profile" do
				[:email, :password].each do |input|
					fill_in( "user_#{input.to_s}", :with => @user_data[input] )
				end # fill_in
				click_on( "Login" )
				page.should have_content( @user.company )			
			end # 
		end # root path
	end # signing in		
end # UsersGeneral
