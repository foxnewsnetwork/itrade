# == Schema Information
#
# Table name: locations
#
#  address    :string(255)
#  city       :string(255)
#  country    :string(255)
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  name       :string(255)
#  official   :boolean          default(FALSE), not null
#  shipping   :string(255)      default("EXWORKS"), not null
#  state      :string(255)
#  updated_at :datetime         not null
#  zip        :string(255)
#

require 'spec_helper'
require "factories"
describe Location do
  describe "validations" do
  	before(:each) do
  		@location = Location.new
  		@fields = [:address,:city,:country,:name,:state,:zip]
  	end # before each
  	context "presence" do
			it "should be invalid" do
				pending "THIS TEST HAS BEEN DEFUNCT"
				@location.valid?.should be_false
				@location.errors.each do |error,msg|
					@fields.should include error
					msg.length.should > 0
				end # field
			end # it
		end # presence
		context "uniqueness" do
			before(:each) do
				@valid_location = Factory(:location)
				@invalid_location = Location.new( :name => @valid_location.name )
			end # before each
			it "should have the uniquess error" do
				@invalid_location.errors[:name].each do |msg|
					msg.should =~ /unique/i
				end # each msg
			end # it
		end # uniquness
  end # validations
  describe "before save" do
  	before(:each) do
  		@location_data = Factory.next(:location)
  		@location_data[:name] = "  catMan-los angles_-8f2\n\r"
  		@expected = @location_data[:name].strip.downcase.squeeze(" ").gsub( /(\W|\s|\d|_)/, "" )
  		@location = Location.create @location_data
  	end # before each
  	it "should strip downcase squeeze, etc." do
  		@location.name.should eq @expected
  	end # its name
  end # before save
end # Location
