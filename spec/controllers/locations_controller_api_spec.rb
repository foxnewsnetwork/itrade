require 'spec_helper'
require 'factories'

describe LocationsController do
	describe "index" do
		before(:each) do
			10.times do 
				(@locations ||= []) << Factory(:location) 
				@locations.last.make_official
			end # 10 times
			@names = @locations.map { |l| l.name }
			@methods = { 
				:vanilla => lambda { get "index" , :format => "json" },
				:ajax => lambda { xhr :get, "index", :format => "json" }
			} # methods
		end # before each
		it "should have a bunch of locations" do
			Location.where(:official => true).each do |location|
				@locations.should include location
			end # each location
		end # it
		[:vanilla, :ajax].each do |style|
			it "should return all the locations" do
				@methods[style].call
				data = MultiJson.load(response.body)
				data['locations'].each do |location|
					@names.should include location['name']
				end # each location
			end # it
		end # each style
	end # index
end # LocationsController
