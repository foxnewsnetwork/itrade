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
	describe "find_by_all_fields" do
		before(:each) do
			15.times do
				(@yard_data ||= []) << Factory.next(:yard)
				(@yard ||= []) << Yard.create( @yard_data.last )
			end # 15 times
			@k = rand(15)
			@result = Yard.find_by_all_fields( @yard_data[@k] )
		end # before each
		it "should not find crap" do
			Yard.find_by_all_fields( Factory.next(:yard) ).should be_nil
		end # it
		it "should find what I want" do
			@result.should eq @yard[@k]
		end # it
	end # find by all fields
  describe "create on duplicate" do
  	before(:each) do
  		@bad_data = Factory.next(:yard)
  		@good_data = Factory.next(:yard)
  		@bad_yard = Yard.create @bad_data
  		5.times do
	  		(@other_yards ||= []) << Factory(:yard)
  		end # t times
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
