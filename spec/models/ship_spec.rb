# == Schema Information
#
# Table name: ships
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
describe Ship do
  describe "factories" do
  	before(:each) do
  		@start = Factory(:location)
  		@finish = Factory(:location)
  		@ship = Factory(:ship, :origination => @start, :destination => @finish )
  	end # before each
  	it "should have the correct ids" do
  		@ship.start.should eq @start.id
  	end # it
  	it "should have the correct ids" do
  		@ship.finish.should eq @finish.id
  	end # it
  	[:origination, :destination].each do |thing|
			it "should respond to #{thing}" do
				@ship.should respond_to thing
			end # it
		end # each thing
  	it "should be valid" do
  		@ship.origination.should eq @start
  		@ship.destination.should eq @finish
  	end # it
  end # factories
end # Ship
