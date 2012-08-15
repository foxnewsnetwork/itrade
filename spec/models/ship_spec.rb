# == Schema Information
#
# Table name: ships
#
#  company    :string(255)      not null
#  created_at :datetime         not null
#  expiration :datetime
#  finish     :integer
#  id         :integer          not null, primary key
#  price      :integer          default(0), not null
#  start      :integer
#  updated_at :datetime         not null
#

require 'spec_helper'
require 'factories'
describe Ship do
  describe "factories" do
  	before(:each) do
  		@start = Factory(:port)
  		@finish = Factory(:port)
  		@ship = Factory(:ship).from(@start).to(@finish)
  	end # before each
  	[:origination, :destination].each do |thing|
			it "should respond to #{thing}" do
				@ship.should respond_to thing
			end # it
		end # each thing
  	it "should be valid" do
  		Ship.find(@ship).origination.at.should eq @start
  		Ship.find(@ship).destination.at.should eq @finish
  	end # it
  end # factories
end # Ship
