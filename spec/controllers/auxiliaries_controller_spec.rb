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
							(@ducks ||= []) << Factory(duck).from(Factory(:port)).to(Factory(:port))
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
			@port = Factory(:port)
			@yard = Factory(:yard)
			@port_data = Factory.next(:port)
		end # before each
		it "should be an admin" do
			@current_user.admin.should be_true
			@current_user.should be_valid
			User.find_by_id(@current_user.id).should_not be_nil
			User.find_by_id(@current_user.id).admin.should be_true
		end # it
		it "should create the yard" do
			expect do
				post :create, :truck => Factory.next(:truck).merge( 
					:start => { :id => @yard.id, :type => @yard.class.to_s.downcase } 
				).merge( :finish => Factory.next(:yard) )
			end.to change(Yard, :count).by(1)
		end # it
		{ :ship => Ship, :truck => Truck, :service => Service }.each do |key, model|
			describe "create #{key.to_s}" do
				before(:each) do
					@data = Factory.next(key)
					@data = @data.merge( 
						:start_id => @port.id, :start_type => @port.class.to_s.downcase ,
						:finish_id => @yard.id , :finish_type => @yard.class.to_s.downcase
					) unless key == :service
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
									
									quack = (faggot==:start ? duck.origination.at : duck.destination.at)
									quack.should_not be_nil
									
									{ Port => @port, Yard => @yard }.each do |m,i|
										[:id, :city].each do |entry|
											quack[entry].should == i[entry] if quack.is_a? m
										end # each entry
									end # each m,i
								end # it
							end # each faggot
						end # if key != service
					end # when style
				end # each style
			end # create
		end # each key model
	end # as admin
end # AuxiliariesController
