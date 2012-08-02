require 'spec_helper'
require 'factories'

describe "UserSignups" do
	subject { page }
	before(:each) do
		@user_data = Factory.next(:user)
		visit new_user_registration_path
	end # before each
	it "should not missing translations" do
		should_have_translations( html )
	end # it
	[:email, :password, :company, :phone].each do |field|
		it { should have_selector( "input", :name => "user_#{field.to_s}" ) }
	end # each field
	context "when given crap for data" do
		it "should not do anything" do
			expect do 
				click_button( "submit-user-button" )
			end.not_to change(User, :count)
		end # it
	end # crap
	context "when given good data" do
		before(:each) do
			within( "#new_user" ) do
				[:email, :password, :company, :phone].each do |field|
					fill_in( "user[#{field.to_s}]", :with => @user_data[field] )
				end # each field
			end # within new user
		end # each
		it "should change the db" do
			expect do 
				click_button("submit-user-button") 
			end.to change(User, :count).by(1)
		end # it
	end # good data
end # UserSignups
