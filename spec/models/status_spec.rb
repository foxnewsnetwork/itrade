# == Schema Information
#
# Table name: statuses
#
#  created_at :datetime         not null
#  effect     :string(255)
#  id         :integer          not null, primary key
#  item_id    :integer          not null
#  name       :string(255)      default("incomplete"), not null
#  updated_at :datetime         not null
#

require 'spec_helper'
require "factories"
describe Status do
  describe "item status" do
		before(:each) do
			@user = User.create Factory.next(:user)
			@user2 = User.create Factory.next(:user)
			@items = {  
				:incomplete => Item.create ,
				:ready => Factory(:item, :user => @user) ,
				:sold => Factory(:item, :user => @user).sold_to( @user2 ) ,
				:recurring => Factory(:item, :user => @user).recurring(4.days)
			} # items
			@actions = [
				lambda { Item.create } ,
				lambda { Factory(:item, :user => @user) } ,
				lambda { Factory(:item, :user => @user).sold_to( @user2 ) } ,
				lambda { Factory(:item, :user => @user).recurring(rand(23).days) }
			] # actions
		end # before each

		4.times do |k|
			it "should change the status database" do
				@actions[k].should change( Status, :count ).by(k/2 + 1)
			end # it
		end # 4 times
		{:incomplete => 1, :recurring => 2, :sold => 2, :ready => 1}.each do |stat, num|
			it "should kill an all the statuses" do
				expect do
					@items[stat].destroy
				end.to change(Status, :count).by(0-num)
			end # it
			it "should have a correct default" do
				@items[stat].statuses.count.should eq num
				@items[stat].statuses.last.name.should eq stat.to_s
			end # it
		end # each stat
		[ :sold_to, :recurring ].each do |method|
			it "should respond to #{method}" do
				@items.each do |key, item|
					item.should respond_to method
				end # each item
			end # it
		end # each method
		it "should tell me who the bought it" do
			@items[:sold].sold_to.should eq @user2
		end # it
		it "should let me know how many days for recurrance" do
			@items[:recurring].recurring.should eq 4.days
		end # it
		it "should have the correct status" do
			@items.each do |key, item|
				item.statuses.last.name.should eq key.to_s
			end # each
		end # it
		
	end # item status
end # Status
