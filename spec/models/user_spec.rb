# == Schema Information
#
# Table name: users
#
#  address                :string(255)      not null
#  admin                  :boolean          default(FALSE)
#  city                   :string(255)      not null
#  company                :string(255)      default(""), not null
#  country                :string(255)      default(""), not null
#  created_at             :datetime         not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  id                     :integer          not null, primary key
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  phone                  :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0)
#  state                  :string(255)      default(""), not null
#  updated_at             :datetime         not null
#  zip                    :string(255)      default(""), not null
#

require 'spec_helper'
require "factories"
describe User do
	describe "validations" do
		before(:each) do 
			@errors = [:email, :password, :address, :city, :company, :country, :phone, :state, :zip]
		end # before each
		it "should not be valid and have all the appropriate errors" do
			user = User.new
			user.should_not be_valid
			@errors.each do |error|
				user.errors[error].should_not be_nil
				(user.errors[error].length > 0).should be_true
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
