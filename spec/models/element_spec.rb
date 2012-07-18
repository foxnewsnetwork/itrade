# == Schema Information
#
# Table name: elements
#
#  created_at           :datetime         not null
#  id                   :integer          not null, primary key
#  item_id              :integer
#  metadata             :string(255)
#  picture_content_type :string(255)
#  picture_file_name    :string(255)
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#  updated_at           :datetime         not null
#

require 'spec_helper'
require "factories"

describe Element do
  describe "creation" do
  	before(:each) do
  		@user = Factory(:user)
  		@item = Factory(:item, :user => @user)
  		@element = Factory(:element, :item => @item)
  	end # before each
  	it "should be valid" do
  		Element.find_by_id(@element.id).should_not be_nil
  		@element.picture.should_not be_nil
  	end # it
  	it "should be properly linked" do
  		@item.elements.should include @element
  	end # it
  end # creation
  describe "relational delete" do
  	before(:each) do
  		@user = Factory(:user)
  		@item = Factory(:item, :user => @user)
  		@element = Factory(:element, :item => @item)
  	end # before each
  	it "should kill this element" do
  		@item.destroy
  		Element.find_by_id(@element).should be_nil
  	end # it
  end # relational delete
end # Element
