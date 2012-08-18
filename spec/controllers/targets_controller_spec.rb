require 'spec_helper'
require 'factories'
describe TargetsController do
	describe "query" do
		before(:each) do
			1.times do |k|
				(@yards ||= []) << Factory(:yard)
				(@ports ||= []) << Port.create( Factory.next(:port).merge( :domestic => false ) )
				10.times do
					exchange = Factory(:port)
					if k == 0
						(@good_trucks ||= []) << Factory(:truck).from(@yards.last).to(exchange)
						(@good_ships ||= []) << Factory(:ship).from(exchange).to(@ports.last)
					else
						(@evil_trucks ||= []) << Factory(:truck).from(@yards.last).to(exchange)
						(@evil_ships ||= []) << Factory(:ship).from(exchange).to(@ports.last)
					end # k == 0
				end # 15.times
			end # 2 times
		end # before each
		1.times do |n|
			describe "stuff #{n}" do
				before(:each) do
					xhr :get, :index, :yard_id => @yards[n].id, :port_id => @ports[n].id
					@combo = assigns[:combos][rand(10)]
				end
				it "should respond nicely #{n}" do
					response.should render_template "index"
					assigns(:combos).should_not be_nil
					assigns(:combos).should_not be_empty
					assigns(:combos).count.should == 10
				end # it
				['start','finish','ship_price','truck_price','truck_id','ship_id','exchange'].each do |field|
					it "#{field}" do 
						@combo[field].should_not be_nil 
					end
				end # each field
				{ 'truck_id' => Truck, 'ship_id' => Ship }.each do |key, val|
					it "#{key} => #{val.to_s}" do
						val.find_by_id(@combo[key]).should_not be_nil
					end # key => val
				end # each key,  val
				it "should have correct start" do
					assigns(:combos).each do |combo|
						@yards.should include Target.find_by_id( combo['start'] ).retrieve
					end # combo
				end # it
				it "should have correct finish" do
					assigns(:combos).each do |combo|
						@ports.should include Target.find_by_id( combo['finish'] ).retrieve
					end # combo
				end # it
				it "shouuld ascending prices" do
					price = -1
					assigns(:combos).each do |combo|
						price.should <= combo['ship_price'] + combo['truck_price']
						price = combo['ship_price'] + combo['truck_price']
					end # it
				end # it
			end # stuff n
		end # 2 times
	end # query
end # TargetsController
