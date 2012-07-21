# == Schema Information
#
# Table name: items
#
#  category    :string(255)      default("plastic"), not null
#  created_at  :datetime         not null
#  description :text
#  id          :integer          not null, primary key
#  location_id :integer
#  material    :string(255)
#  quantity    :integer          default(0)
#  title       :string(255)      default("No title")
#  units       :string(255)      default("kg")
#  updated_at  :datetime         not null
#  user_id     :integer
#

require 'spec_helper'
require "factories"
describe Item do
  describe "Item creation" do
  	it "should have proper default values" do
  		item = Item.create
  		item.title.should eq( "No title" )
  		item.quantity.should eq( 0 )
  		item.units.should eq( "kg" )
  	end # it
  end # Creation
  describe "item location" do
  	before(:each) do
  		@item = Factory(:item)
  		@location = Factory(:location)
  		@test = lambda do
  			Item.find_by_id(@item).location.should eq @location
  			Location.find_by_id(@location).items.should include @item
  		end # test
  	end # before each
  	it "should allow an item to pin its location" do
  		@item.at @location
  		@test.call
  	end # it
  	it "should allow a location to have an item" do
  		@location.has @item
  		@test.call
  	end # it
  end # item location
end # Item
