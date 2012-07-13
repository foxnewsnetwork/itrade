# == Schema Information
#
# Table name: items
#
#  created_at  :datetime         not null
#  description :text
#  id          :integer          not null, primary key
#  quantity    :integer          default(0)
#  title       :string(255)      default("No title")
#  units       :string(255)      default("kg")
#  updated_at  :datetime         not null
#

require 'spec_helper'
# require "factories"
describe Item do
  describe "Item creation" do
  	it "should have proper default values" do
  		item = Item.create
  		item.title.should eq( "No title" )
  		item.quantity.should eq( 0 )
  		item.units.should eq( "kg" )
  	end # it
  end # Creation
end # Item
