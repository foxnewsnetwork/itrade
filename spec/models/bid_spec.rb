# == Schema Information
#
# Table name: bids
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  item_id    :integer          not null
#  offer      :integer          default(0)
#  units      :string(255)      default("USD")
#  updated_at :datetime         not null
#  user_id    :integer
#

require 'spec_helper'
require "factories"
describe Bid do
  describe "creation" do
  	before(:each) do
  		@item = Factory(:item)
  	end # before each
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
end # Bid
