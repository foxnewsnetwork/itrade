# == Schema Information
#
# Table name: trucks
#
#  company    :string(255)      not null
#  created_at :datetime         not null
#  finish     :integer          not null
#  id         :integer          not null, primary key
#  price      :integer          default(0), not null
#  start      :integer          not null
#  updated_at :datetime         not null
#

require 'spec_helper'
require 'factories'
describe Truck do
  describe "factories" do
  	before(:each) do
  		@start = Factory(:location)
  		@finish = Factory(:location)
  		@truck = Factory(:truck, :origination => @start, :destination => @finish )
  	end # before each
  	[:origination, :destination].each do |thing|
			it "should respond to #{thing}" do
				@truck.should respond_to thing
			end # it
		end # each thing
  	it "should be valid" do
  		@truck.origination.should eq @start
  		@truck.destination.should eq @finish
  	end # it
  end # factories
end # Truck
