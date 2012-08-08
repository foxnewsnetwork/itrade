require 'spec_helper'
require 'factories'
describe "UserLogins" do
	before(:each) do
		@user_data = Factory.next(:user).merge( :password => "massive faggot" )
		@user = User.create @user_data
		@signin = lambda do 
			fill_in "login_user_email", :with => @user_data[:email]
			fill_in "login_user_password", :with => @user_data[:password]
			click_on "submit-login-button"
		end # signin
		@paths = [root_path, items_path, new_item_path]
	end # before each
	3.times do |k|
	  describe "from #{k}" do
  		before(:each) do
  			@place = @paths[k]
  			visit @place
  		end # before each
  		it { should_have_translations(page.html) }
  		it "should redirect back" do
  			@signin.call
  			URI(current_url).path.should eq @place
  		end # it
  	end # from place
  end # each place
end # UserLogins
