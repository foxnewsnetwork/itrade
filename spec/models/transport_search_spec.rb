require 'spec_helper'
require 'factories'

def get1( something )
	case something.class.to_s.downcase
		when 'array'
			something[rand(something.count)]
		when 'hash'
			something[something.keys[rand(something.keys.count)]]
		else
			raise "Incorrect Usage Error #{something.class.to_s}"
	end # case
end # get1

describe "get1" do
	before(:each) do
		@array = [1]
		@hash = { :a => 1 }
	end # before each
	it "should be 1" do
		get1(@array).should eq 1
	end # it
	it "should still be 1" do
		get1(@hash).should eq 1
	end # it
end # get1

[Truck, Ship].each do |slut|
	describe slut do
		before(:each) do
			10.times do |n|
				(@sluts ||= []) << Factory(slut.to_s.downcase.to_sym)
				if slut.is_a? Truck
					@sluts.last.from(Factory(:yard)).to(Factory(:yard))
				else
					@sluts.last.from(Factory(:port)).to(Factory(:port))
				end # if truck
			end # 10 times
		end # before each
		describe 'response' do
			['by_price', 'by_origin', 'by_destination'].each do |cock|
				it "should respond to #{cock}" do
					slut.should respond_to( cock.to_sym )
				end # it
			end # each cock
		end # response
		describe "by_price" do
			subject { slut.by_price }
			it { should eq slut.order( "price ASC" ) }
		end # by_price
		[ :by_origin, :by_destination ].each do |function|
			describe "#{function.to_s}" do
				before(:each) do
					@slut = get1(@sluts)
					if function == :by_origin
						@origin = @slut.origination.at
						@whorehouse = slut.by_origin @origin
					else
						@destination = @slut.destination.at
						@whorehouse = slut.by_destination @destination
					end # if by origin
				end # before each
				[:each, :count].each do |method|
					it "should #{method}" do
						@whorehouse.should respond_to method
					end # it
				end # each method
				it "one and only" do
					@whorehouse.count.should eq 1
				end # it
				it "should be right" do
					@whorehouse.should include @slut
				end # it
			end # by_function
		end # each function
	end # describe Truck
end # each slut
