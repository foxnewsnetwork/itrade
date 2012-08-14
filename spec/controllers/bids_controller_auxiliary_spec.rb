require 'spec_helper'
require 'factories'

describe BidsController do
	describe "correct user" do
		login_user
		before(:each) do
			@user = User.create Factory.next(:user)
			@item = Factory(:item, :user => @user)
			@item.at Factory(:yard)
			@destination = Factory(:port)
			luck = [:ship, :truck, :service][rand(3)]
			@duck = Factory(luck) if luck == :service
			@duck ||= Factory(luck).from(Factory(:port)).to(Factory(:port))
			@data =  { 
				:bid => Factory.next(:bid) ,
				:auxiliaries => [{ :id => @duck.id, :type => @duck.class.to_s.downcase }] ,
				:port => { :city => @destination.city, :code => @destination.code, :id => @destination.id }
			} # data
			@method = lambda { post :create, @data.merge( :item_id => @item.id ) }
		end # before each
		[Bid, Auxiliary].each do |model|
			it "should create a #{model.to_s}" do
				@method.should change(model, :count).by(1)
			end # it
		end # each model
		[Port, Location, Truck, Ship, Service].each do |model|
			it "should not change the #{model.to_s}" do
				@method.should_not change(model, :count)
			end # it
		end # each model
		describe "functionality" do
			before(:each){ @method.call }
			[:bid, :auxiliaries].each do |thing|
				it "should have the #{thing}" do
					assigns(thing).should_not be_nil
				end # it
			end # each thing
			it "should retrieve the right duck" do
				assigns(:auxiliaries).first.retrieve.should eq @duck
			end # it
		end # functionality
	end # correct user
end # BidsController
