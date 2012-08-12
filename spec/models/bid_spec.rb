# == Schema Information
#
# Table name: bids
#
#  created_at  :datetime         not null
#  id          :integer          not null, primary key
#  item_id     :integer          not null
#  location_id :integer
#  maw         :integer
#  offer       :integer          default(0)
#  paydate     :datetime
#  paytype     :string(255)
#  units       :string(255)      default("USD")
#  updated_at  :datetime         not null
#  user_id     :integer
#

require 'spec_helper'
require "factories"
describe Bid do
	describe "normal items" do
		before(:each) do
			@user = User.create Factory.next(:user)
			@item = Factory(:item, :user => @user)
			@locations = (0..3).map { Factory(:location) }
			@bids = (0..2).map { @user.bid( {:offer => rand(555)}, @item )}
		end # before each
		it "should allow the owner to set initial prices for his items" do
			@bids.each do |bid|
				@user.bids.should include bid
			end # each bid
		end # it
		it "should have the suggested price macro" do
			@item.should respond_to :suggested_prices
		end # it
		it "should spit out the correct self-user bids" do
			@item.suggested_prices.each do |price|
				@bids.should include price
			end # each price
		end #it
	end # normal items
	describe "orphaned items" do
		before(:each) do
			@user = Factory(:user)
			@item = Factory(:item, :user => @user)
		end # before each
		describe "location relation" do
			before(:each) do		
				@bid = @item.bid
				@location = Factory(:location)
				@test = lambda do 
					Bid.find_by_id(@bid).location.should == @location
					Location.find_by_id(@location).bids.should include @bid
				end # test
			end # before each
			it "should be properly related" do
				@bid.at @location
				@test.call
			end # it
			it "should be properly related reverse" do
				@location.has @bid
				@test.call
			end # it
		end # location relation	
		describe "creation" do
			it "should have proper relationship" do
				bid = @item.bid
				bid.should_not be_nil
				@item.bids.should include(bid)
				bid.item.should eq(@item)
			end # it
			it "should hae proper defaults" do
				bid = @item.bid
				bid.offer.should eq 0
				bid.units.should eq "USD"
			end # it
			it "should give me the bids in order of offer price" do
				(0..10).each { @item.bid( :offer => rand(450) ) }
				@item.bids.length.should eq 11
				price = @item.bids.first.offer
			end # it
		end # creation
	end # orphaned item
end # Bid
