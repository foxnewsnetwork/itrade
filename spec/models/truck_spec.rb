# == Schema Information
#
# Table name: trucks
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
describe Truck do
	describe "helpers-just-find-it" do
		before(:each) do
			@yard_data = Factory.next(:yard)
			@yard = Yard.create @yard_data
			
			@clean_data = Factory.next(:yard)
		end # before each
		it "should create" do
			expect do
				Target.just_find_it @clean_data
			end.not_to change(Yard, :count)
		end # it
		it "should not create" do
			expect do
				Target.just_find_it( @yard_data )
			end.not_to change(Yard, :count)
		end # it
		it "should find it" do
			Target.just_find_it( @yard_data ).should eq @yard
		end # it
		it "should not find it" do
			Target.just_find_it( @clean_data ).should be_nil
		end # it
	end # helpers
  describe "factories" do
  	before(:each) do
  		@start = Factory(:yard)
  		if rand(100) > 49
	  		@finish = Factory(:yard)
	  	else
	  		@finish = Factory(:port)
	  	end # if 50% change
  		@truck = Factory(:truck).from(@start).to(@finish)
  	end # before each
  	[:origination, :destination].each do |thing|
			it "should respond to #{thing}" do
				@truck.should respond_to thing
			end # it
		end # each thing
  	it "should be valid" do
  		Truck.find(@truck).origination.at.should eq @start
  		Truck.find(@truck).destination.at.should eq @finish
  	end # it
  end # factories
end # Truck
