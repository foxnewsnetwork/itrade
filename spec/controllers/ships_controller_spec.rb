require 'spec_helper'
require 'factories'
describe ShipsController do
	before(:each) do
		5.times do
			[:domestic, :foreign].each do |field|
				((@ports ||= {})[field] ||= []) << Factory(:port)
			end # each field
			((@ships ||= {})[:ship] ||= []) << Factory(:ship).from(@ports[:domestic].last).to(@ports[:foreign].last)
		end # 5 times
	end # before each
	[:create, :destroy].each do |gtfo|
		describe "GTFO #{gtfo}" do
			before(:each) do
				@methods = { :create => lambda { post :create }, :destroy => lambda { delete :destroy, :id => rand(39339) } }
			end # before each
			it "should not change the database" do
				@methods[gtfo].should_not change(Ship, :count)
			end # it
			it "should redirect" do
				@methods[gtfo].call
				response.status.should == 302
			end # it
		end # GTFO
	end # each gtfo
	[:id, :code].each do |field|
		describe "search by #{field}" do
			before(:each) do
				@searches = {}
				@searches[:start] = { :start => @ports[:domestic].last[field] }
				@searches[:finish] = { :finish => @ports[:foreign].first[field] }
				@searches[:both] = { :start => @ports[:domestic][2], :finish => @ports[:foreign][2] }
				@expected = {}
				@expected[:start] = [@ships[:ship].last]
				@expected[:finish] = [@ships[:ship].first]
				@expected[:both] = [@ships[:ship][2]]
			end # before each
			it "should have some ships" do
				Ship.count.should eq 5
			end # it
			[:start, :finish, :both].each do |search|
				describe "params #{search}" do
					before(:each) { get "index", @searches[search].merge( :format => "json") }
					it "should pull relevant data" do
						data = MultiJson.load(response.body)
						data['ships'].count.should eq 1
						@expected[search].each do |ship|
							data['ships'].each do |shit|
								[:id, :name, :code].each do |a|
									ship[a].should == shit[a.to_s]
								end # each a
							end # each shit
						end # each ship
					end # it
				end # params search
			end # each search
		end # search field
	end # each field
	describe "admin" do
		login_admin
		before(:each) do
			5.times do
				(@ships[:data] ||= []) << Factory.next(:ship).merge( 
					:origination => { :code => @ports[:domestic].last.code }, 
					:destination => { :code => @ports[:foreign].last.code }
				) # next ship
			end # 5times
			@creates = { 
				:vanilla => lambda { post :create, :ships => @ships[:data] } ,
				:ajax => lambda { xhr :post, :create, :ships => @ships[:data] }
			} # creates
			@destroys = { 
				:vanilla => lambda { delete :destroy, :id => @ships[:ship].first.id } ,
				:ajax => lambda { xhr :delete, :destroy, :id => @ships[:ship].first.id }
			} # pupts
		end # before each
		[:vanilla, :ajax].each do |style|
			describe "#{style} destroy" do
				it "should change the db" do
					@destroys[style].should change(Ship, :count).by(-1)
				end # it
				it "should destroy the right one" do
					@destroys[style].call
					Ship.find_by_id(@ships[:ship].first.id).should be_nil
				end # it
			end # style destroy
			describe "#{style} create" do
				it "should change the database" do
					@creates[style].should change(Ship, :count).by(5)
				end # it
			end # style create
		end # each style
	end # admin
end # ShipsController
