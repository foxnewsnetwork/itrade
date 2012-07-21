# == Schema Information
#
# Table name: users
#
#  admin                  :boolean          default(FALSE)
#  company                :string(255)      default(""), not null
#  created_at             :datetime         not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  extention              :string(255)
#  id                     :integer          not null, primary key
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  location_id            :integer
#  phone                  :string(255)      default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0)
#  updated_at             :datetime         not null
#

require 'spec_helper'
require "factories"
describe User do
	describe "locations" do
		before(:each) do
			@user = User.create Factory.next(:user)
			@location = Factory(:location)
			@spec = lambda do
				@user.at.should eq @location
				@location.users.should include @user
			end # spec
		end # before each
		it "should give proper locations" do
			@user.at @location
			@spec.call
		end # it
		it "should go the other way also" do
			@location.has @user
			@spec.call
		end # it
	end # locations
	describe "before saves" do
		before(:each) do
			@user_data = Factory.next(:user)
			@user_data[:company] = "   cLuSterf02  fuck  \r\n"
			@user = User.create @user_data
			@expected = @user_data[:company].strip.downcase.squeeze(" ").gsub( /[^a-zA-Z0-9 ]/, "" )
		end # before each
		subject { @user }
		its(:company) { should == @expected }
	end # before save
	describe "validations" do
		before(:each) do 
			@errors = [:email, :password, :company, :phone]
		end # before each
		it "should not be valid and have all the appropriate errors" do
			user = User.new
			user.should_not be_valid
			@errors.each do |error|
				user.errors[error].should_not be_nil
				user.errors[error].should_not be_empty
			end # each error
		end # it
	end # validations
	describe "Factories" do
		before(:each) do
			@user = Factory(:user)
		end # before each
		after(:each) do
			@user.destroy
		end # after(:each)
		it "should be valid" do
			Factory.next( :user ).should_not be_nil
		end # it
		it "should create a user" do
			@user.should_not be_nil
		end # it
	end # factories
	describe "having items" do
		before(:each) do
			@user = Factory :user
			@items = (0..9).map { Factory( :item, :user => @user ) }
		end # before each
		it "should respond to having items" do
			@user.should respond_to :items
			@user.items.each { |item| @items.should include item }
		end # it
		it "should dependent destroy" do
			@user.destroy
			@items.each do |item|
				Item.find_by_id(item.id).should be_nil
			end # each
		end # it
	end # having items
	describe "bidding on items" do
		before(:each) do
			@seller = Factory(:user)
			@buyer = User.create( Factory.next(:user) )
			@product = Factory( :item, :user => @seller )
			@bid = { 
				:offer => rand(500) ,
				:item_id => @product.id
			} # bid
		end # before each
		it "should allow bidding" do
			bid = @buyer.bid( @bid, @product.id )
			bid.item.should eq @product
			bid.user.should eq @buyer
			Item.find_by_id(@product.id).bids.should include bid
		end # it
	end # bidding on items
end # User
