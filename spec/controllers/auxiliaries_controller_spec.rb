require 'spec_helper'
require 'factories'
describe AuxiliariesController do
	describe "as anonymous" do
		describe "create" do
			before(:each) do
				@methods = [ lambda { post :create, Factory.next(:random_hash) } , lambda { xhr :post, :create, Factory.next(:random_hash) } ]
				@methods[rand(2)].call
			end # before each
			it "should have flash" do
				flash[:error].should_not be_nil
			end # it
		end # create
		[:ship, :truck, :service].each do |duck|
			describe "index-#{duck}" do
				before(:each) do
					10.times do
						unless duck == :service
							(@ducks ||= []) << Factory(duck, :origination => Factory(:location), :destination => Factory(:location))
						else
							(@ducks ||= []) << Factory(duck)
						end # service duck
					end # 10 times
					get "index", :q => duck.to_s, :format => "json"
				end # before each
				it "should present the json" do
					data = MultiJson.load response.body
					data[duck.to_s.pluralize].count.should == @ducks.count
					data[duck.to_s.pluralize].each do |datum|
						match = false
						@ducks.each do |dick|
							if datum['id'] == dick.id && datum['company'] == dick.company
								match = true 
							end # if match
						end # each dick
						match.should be_true
					end # each datum
				end # it
			end # index duck
		end # each duck
	end # as anonymous
	describe "factories" do
		before(:each) do
			@location = Factory(:location)
		end # b4 each
		it "should be valid" do
			@location.should be_valid
			[:name, :address, :city, :state, :country].each do |field|
				Location.find_by_id(@location)[field].should_not eq ""
			end # each field
		end # it
	end # factories
	describe "as admin" do
		login_admin
		before(:each) do
			@seller = User.create Factory.next(:user)
			@item = Factory(:item, :user => @seller)
			@bid = Factory(:bid, :user => @current_user, :item => @item)
			[:start, :finish].each do |a|
				(@locations ||= {} )[a] = [ { :id => Factory(:location).id },Factory.next(:location) ]
			end # each a
		end # before each
		it "should be an admin" do
			@current_user.admin.should be_true
			@current_user.should be_valid
			User.find_by_id(@current_user.id).should_not be_nil
			User.find_by_id(@current_user.id).admin.should be_true
		end # it
		{ :ship => Ship, :truck => Truck, :service => Service }.each do |key, model|
		# { :ship => Ship }.each do |key, model|
			2.times do |k|
			# 1.times do |k|
				describe "create #{key.to_s} in #{k}" do
					before(:each) do
						@data = Factory.next(key)
						@data = @data.merge( :start => @locations[:start][k], :finish => @locations[:finish][k] ) unless key == :service
						@methods = { 
							:vanilla => lambda { post :create, key => @data } ,
							:ajax => lambda { xhr :post, :create, key => @data }
						} # methods
					end # before each
				[:vanilla, :ajax].each do |style|
				#	[:vanilla].each do |style|
						describe "style #{style.to_s}" do
							it "should change the #{key} db" do
								@methods[style].should change(model, :count).by(1)
							end # it
							it "should spawn locations" do
								if k == 0 || key == :service
									@methods[style].should_not change(Location, :count)
								else
									@methods[style].should change(Location, :count).by(2)
								end # if k
							end # it
							if key != :service
								[ :start, :finish ].each do |faggot|
								# [ :start ].each do |faggot|
									it "when #{faggot.to_s}" do
										@methods[style].call
										ducks = assigns(:ducks)
										ducks.should_not be_nil
										
										duck = ducks[key]
										duck.should_not be_nil
										
										duck.finish.class.should == Fixnum
										duck.start.class.should == Fixnum
										
										quack = (faggot==:start ? duck.origination : duck.destination)
										quack.should_not be_nil
										if k == 0
											quack[:id].should == @locations[faggot][k][:id]
										else
											[:address, :city, :state, :country].each do |field|
												quack[field].should == @locations[faggot][k][field]
											end # each field
										end # if k 0
									end # it
								end # each faggot
							end # if key != service
							if k==1 && key != :service
								it "should have the correct locations" do
									@methods[style].call
									assigns(:locations).should_not be_nil
									[:start, :finish].each do |p|
										place = assigns(:locations)[p]
										place.should_not be_nil
										expected_place = @locations[p]
										expected_place.should_not be_nil
										place.should_not be_nil
										expected_place[k].should_not be_nil
										[:country, :address, :city, :state].each do |f|
											field = place[f]
											expected_field = expected_place[k][f]
											field.should_not be_nil
											expected_field.should_not be_nil
											field.should eq expected_field
										end # each field
									end # each place
								end # it
							end # if k 1
						end # when style
					end # each style
				end # create
			end # 2 times k
		end # each key model
	end # as admin
end # AuxiliariesController
