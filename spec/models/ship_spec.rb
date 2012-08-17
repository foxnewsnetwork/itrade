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
	describe "generic search" do
		before(:each) do
			5.times do |n|
				(@starts ||= []) << (rand(2) > 0 ? Factory(:yard) : Factory(:port) )
				(@finishes ||= []) << Factory(:yard)
				(@trucks ||= []) << Factory(:truck).from(@starts.last).to(@finishes.last)
				(@evil_trucks ||= []) << Factory(:truck).to(Factory(:yard)).from(Factory(:yard))
			end # 5 times
			@results = Truck.from( @starts )
			@results2 = Truck.to( @finishes )
			@results3 = Truck.to_and_from( @finishes, @starts )
		end # before each
		it "should match count" do
			@trucks.count.should eq @results.count
		end # it
		it "should every element" do
			@trucks.each do |truck|
				@results.should include truck
			end # each truck
		end # it
		it "should match count" do
			@trucks.count.should eq @results3.count
		end # it
		it "should every element" do
			@trucks.each do |truck|
				@results3.should include truck
			end # each truck
		end # it
		it "should match count" do
			@trucks.count.should eq @results2.count
		end # it
		it "should every element" do
			@trucks.each do |truck|
				@results2.should include truck
			end # each truck
		end # it
	end # generic search
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
