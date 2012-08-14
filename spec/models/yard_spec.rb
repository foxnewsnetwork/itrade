# == Schema Information
#
# Table name: yards
#
#  city           :string(255)
#  created_at     :datetime         not null
#  id             :integer          not null, primary key
#  state          :string(255)
#  street_address :string(255)
#  updated_at     :datetime         not null
#  zip            :string(255)
#

require 'spec_helper'
require 'factories'
describe Yard do
  describe "create on duplicate" do
  	before(:each) do
  		@bad_data = Factory.next(:yard)
  		@good_data = Factory.next(:yard)
  		@bad_yard = Yard.create @bad_data
  	end # before each
  	it "should create the yard" do
  		expect do
  			Yard.create_on_duplicate(@good_data)
  		end.to change(Yard, :count).by(1)
  	end # it
  	it "should not create the yard" do
  		expect do
  			Yard.create_on_duplicate(@bad_data)
  		end.not_to change(Yard, :count)
  	end # it
  	it "should return the matching yard" do
  		Yard.create_on_duplicate(@bad_data).should eq @bad_yard
  	end # it
  	Yard.attr_accessible[:default].each do |attribute|
  		next if attribute.blank?
			describe "match #{attribute}" do
				before(:each) do
					@good_yard = Yard.create_on_duplicate(@good_data)
				end # before each
				it { @good_yard[attribute.to_sym].should eq @good_data[attribute.to_sym] }
			end # match attribute
  	end # each attribute
  end # duplicate
end # Yard
