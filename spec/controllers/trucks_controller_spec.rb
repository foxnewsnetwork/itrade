require 'spec_helper'
require 'factories'

describe TrucksController do
	def get1( array )
		return array[rand(array.count)] if array.is_a? Array
		return array[array.keys[rand(array.keys.count)]] if array.is_a? Hash
	end # get1
	before(:each) do
		10.times do
			(@yard_data ||= []) << Factory.next(:yard)
			(@yards ||= []) << Yard.create( @yard_data.last )
			(@ports ||= []) << Factory(:port)
		end # 10 times
	end # before each
	describe "search" do
		before(:each) do
			10.times do |n|
				(@trucks ||= []) << Factory(:truck).from(@yards[n]).to(@ports[n])
				(@queries ||= []) << ( { 
					:s => { 
						:type => "yard", 
						:id => @yards[n].id
					} , # s
					:f => { 
						:type => "port" ,
						:id => @ports[n].id	
					} # f
				} ) # queries
			end # 10 times
		end # before each
		it "should have any aimless trucks" do
			Truck.all.each do |truck|
				truck.origination.at.should_not be_nil
				truck.destination.at.should_not be_nil
			end # truck
		end # it
		describe "match" do
			before(:each) do
				@k = rand(10)
				get "index", @queries[@k].merge(:format => "json")
				@data = MultiJson.load(response.body)['trucks']
			end # before each
			it "should not be fucking retarded" do
				# puts @data
				@data.should_not be_nil
				@data.class.should eq Array
				@data.count.should eq 1
				@data.first['destination'].should_not be_nil
				@data.first['origination'].should_not be_nil
			end # it
			[:company, :price].each do |field|
				it "should match #{field}" do
					@data.count.should eq 1
					@data.each do |truck|
						@trucks[@k][field].should eq truck[field.to_s]
					end # each truck
				end # it
			end # each field
			Yard.attr_accessible[:default].each do |field|
				next if field.blank?
				it "origin should match #{field}" do
					location = @trucks[@k].origination.at
					location.should_not be_nil
					
					expected = @data.first['origination'][field]
					location[field].should eq expected
				end # it
			end # each field
			Port.attr_accessible[:default].each do |field|
				next if field.blank?
				it "origin should match #{field}" do
					location = @trucks[@k].destination.at
					location.should_not be_nil
					
					expected = @data.first['destination'][field]
					location[field].should eq expected
				end # it
			end # each field
		end # match
	end # search
	describe "admin" do
		login_admin
		describe "destroys" do
			before(:each) do
				@truck = Factory(:truck).from(Factory(:port)).to(Factory(:yard))
			end # before each
			{Truck => -1, Target => -2, Yard => 0, Port => 0}.each do |db, amount|
				it "should change the #{db}" do
					if amount != 0
						expect do
							delete :destroy, :id => @truck.id
						end.to change(db, :count).by(amount)
					else
						expect do
							delete :destroy, :id => @truck.id
						end.not_to change(db, :count)
					end # if amount > 0
				end # it
				it "should delete the right things" do
					delete :destroy, :id => @truck.id
					Truck.find_by_id(@truck.id).should be_nil
					Target.find_by_id(@truck.finish).should be_nil
					Target.find_by_id(@truck.start).should be_nil
				end # it
			end # each db amount
		end # destroy
		[ :forward, :reverse ].each do |order|
			describe order == :forward ? "yard -> port" : "port -> yard" do
				describe "pre-existence" do
					before(:each) do
						if order == :forward
							@start = { :origination => get1(@yard_data) }.merge( :o_type => "yard" )
							@finish = { :destination => { :code => @ports.first.code } }.merge( :d_type => "port" )
						else
							@start = { :origination => { :code => @ports.first.code } }.merge( :o_type => "port" )
							@finish = { :destination => get1(@yard_data) }.merge( :d_type => "yard" )
						end # if order
						@truck_data = Factory.next(:truck).merge( @start ).merge( @finish )
						@methods = { 
							:vanilla => lambda { post :create, :trucks => [@truck_data] } ,
							:ajax => lambda { xhr :post, :create, :trucks => [@truck_data] }
						} # methods
					end # before each
					[:vanilla, :ajax].each do |style|
						describe "#{style}" do
							{ Target => 2, Yard => 0, Truck => 1 }.each do |model, amount|
								it { @methods[style].should change( model, :count ).by(amount) }
							end # each model amount
							describe "matches" do
								before(:each) { @methods[style].call }
								[:company, :price].each do |field|
									it "vanilla data-#{field}" do
										assigns(:trucks).each do |truck|			
											truck[field].should eq @truck_data[field]
										end # each truck
									end # it
								end # each field
								Yard.attr_accessible[:default].map { |x| x.to_sym }.each do |a|
									next if a == :""
									it "origination-#{a}" do
										assigns(:trucks).each do |truck|
											if order == :forward
												Truck.find_by_id(truck.id).origination.at[a].should eq @start[:origination][a]
											else
												Truck.find_by_id(truck.id).origination.at[a].should eq @ports.first[a]
											end # if order
										end # each truck
									end # it
								end # each a
								Port.attr_accessible[:default].map { |x| x.to_sym }.each do |a|
									next if a == :""
									it "destination-#{a}" do
										assigns(:trucks).each do |truck|
											if order == :forward
												Truck.find_by_id(truck.id).destination.at[a].should eq @ports.first[a]
											else
												Truck.find_by_id(truck.id).destination.at[a].should eq @finish[:destination][a]
											end # if order
										end # each truck
									end # it
								end # each a
							end # matches
						end # style
					end # each style
				end # pre-existence
				describe "non-existence" do
					before(:each) do
						if order == :forward
							@start = { :origination => Factory.next(:yard) }.merge( :o_type => "yard" )
							@finish = { :destination => { :code => @ports.first.code } }.merge( :d_type => "port" )
						else
							@start = { :origination => { :code => @ports.first.code } }.merge( :o_type => "port" ) 
							@finish = { :destination => Factory.next(:yard) }.merge( :d_type => "yard" )
						end # if order					
						@truck_data = Factory.next(:truck).merge( @start ).merge( @finish )
						@methods = { 
							:vanilla => lambda { post :create, :trucks => [@truck_data] } ,
							:ajax => lambda { xhr :post, :create, :trucks => [@truck_data] }
						} # methods
					end # before each
					[:vanilla, :ajax].each do |style|
						describe "#{style}" do
							{ Target => 2, Yard => 1, Truck => 1 }.each do |model, amount|
								it { @methods[style].should change( model, :count ).by(amount) }
							end # each model amount
							describe "matches" do
								before(:each) { @methods[style].call }
								[:company, :price].each do |field|
									it "vanilla data-#{field}" do
										assigns(:trucks).each do |truck|			
											truck[field].should eq @truck_data[field]
										end # each truck
									end # it
								end # each field
								Yard.attr_accessible[:default].map { |x| x.to_sym }.each do |a|
									next if a == :""
									it "originatio-#{a}" do
										assigns(:trucks).each do |truck|
											if order == :forward
												Truck.find_by_id(truck.id).origination.at[a].should eq @start[:origination][a]
											else
												Truck.find_by_id(truck.id).origination.at[a].should eq @ports.first[a]
											end # order
										end # each truck
									end # it
								end # each a
								Port.attr_accessible[:default].map { |x| x.to_sym }.each do |a|
									next if a == :""
									it "destination-#{a}" do
										assigns(:trucks).each do |truck|
											if order == :forward
												Truck.find_by_id(truck.id).destination.at[a].should eq @ports.first[a]
											else
												Truck.find_by_id(truck.id).destination.at[a].should eq @finish[:destination][a]
											end # if order
										end # each truck
									end # it
								end # each a
							end # matches
						end # style
					end # each style
				end # non-existence
			end # yard -> port
		end # each order
		describe "all yards" do
			describe "non-existence" do
				before(:each) do
					@origination = { :origination => Factory.next(:yard) }.merge( :o_type => "yard" )
					@destination = { :destination => Factory.next(:yard) }.merge( :d_type => "yard" )
					@truck_data = Factory.next(:truck).merge(@origination).merge(@destination) # merge
					@methods = { 
						:vanilla => lambda { post :create, :trucks => [@truck_data] } ,
						:ajax => lambda { xhr :post, :create, :trucks => [@truck_data] }
					} # methods
				end # before each
				[:vanilla, :ajax].each do |style|
					describe "#{style}" do
						{ Target => 2, Yard => 2, Truck => 1 }.each do |model, amount|
							it { @methods[style].should change( model, :count ).by(amount) }
						end # each model amount
						describe "matches" do
							before(:each) do
								@methods[style].call
							end # before each
							[:company, :price].each do |field|
								it "vanilla data-#{field}" do
									assigns(:trucks).each do |truck|			
										truck[field].should eq @truck_data[field]
									end # each truck
								end # it
							end # each field
							Yard.attr_accessible[:default].map { |x| x.to_sym }.each do |a|
								next if a == :""
								it "destination-#{a}" do
									assigns(:trucks).each do |truck|
										Truck.find_by_id(truck.id).destination.at[a].should eq @destination[:destination][a]
									end # each truck
								end # it
								it "originatio-#{a}" do
									assigns(:trucks).each do |truck|
										Truck.find_by_id(truck.id).origination.at[a].should eq @origination[:origination][a]
									end # each truck
								end # it
							end # each a
						end # matches
					end # style
				end # each style
			end # non-existence
			describe "pre-existence" do
				before(:each) do
					@origination = { :origination => get1(@yard_data) }.merge( :o_type => "yard" )
					@destination = { :destination => get1(@yard_data) }.merge( :d_type => "yard" )
					@truck_data = Factory.next(:truck).merge(@origination).merge(@destination) # merge
					@methods = { 
						:vanilla => lambda { post :create, :trucks => [@truck_data] } ,
						:ajax => lambda { xhr :post, :create, :trucks => [@truck_data] }
					} # methods
				end # before each
				it "should not be null" do
					@truck_data.should_not be_nil
				end # it
				[:vanilla, :ajax].each do |style|
					describe "#{style}" do
						it { @methods[style].should change( Truck, :count ).by(1) }
						it { @methods[style].should change( Target, :count ).by(2) }
						it "might change yards" do
							amount = 0
							if amount == 0
								@methods[style].should_not change(Yard, :count)
							else
								@methods[style].should change(Yard, :count).by(amount)
							end
						end # it
						describe "match data" do
							before(:each) { @methods[style].call }
							[:company, :price].each do |field|
								describe "#{field}" do
									it "should have the correct data" do
								
										assigns(:trucks).each do |truck|
											truck[field].should eq @truck_data[field]							
										end # each truck
									end # it
								end # field
							end # each field
							it "should match destination" do
								assigns(:trucks).each do |truck|
									truck.destination.at.should_not be_nil
									truck.destination.at.class.attr_accessible[:default].map { |x| x.to_sym }.each do |att|
										next if att == :""
										Truck.find_by_id(truck.id).destination.at[att].should eq @truck_data[:destination][att]
									end # each att
								end # each truck
							end # it
							it "should origin class" do
								assigns(:trucks).each do |truck|
									truck.origination.at.class.to_s.downcase.should eq @truck_data[:o_type]
								end # each truck
							end # it
							it "should destiny class" do
								assigns(:trucks).each do |truck|
									truck.destination.at.class.to_s.downcase.should eq @truck_data[:d_type]
								end # each truck
							end # it
							it "should match origination" do
								assigns(:trucks).each do |truck|
									truck.origination.at.should_not be_nil
									truck.origination.at.class.attr_accessible[:default].map { |x| x.to_sym }.each do |att|
										next if att == :""
										Truck.find_by_id(truck.id).origination.at[att].should eq @truck_data[:origination][att]
									end # each att
								end # each truck
							end # it
						end # match data
					end # style
				end # each style
			end # pre-exitence
		end # all-yards
	end # admin
end # TrucksController
