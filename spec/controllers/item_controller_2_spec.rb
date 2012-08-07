require 'spec_helper'
require "factories"
describe ItemsController do
	describe "index pulls" do
		before(:each) do
			@user = User.create Factory.next(:user)
			@bad = Item.create
			@good = Factory(:item, :user => @user )
			@items = { 
				:incomplete => @bad ,
				:ready => @good
			}
		end # before each
		[:incomplete, :ready].each do |status|
			it "should be correctly statused" do
				@items[status].statuses.count.should eq 1
				@items[status].statuses.first.name.should eq status.to_s
			end # it
		end # each status
		it "should only show the good item" do
			get :index
			assigns(:items).should_not include @bad
			assigns(:items).should include @good
		end # it
	end # index pulls
end # ItemsController
