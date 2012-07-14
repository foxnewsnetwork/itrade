require 'spec_helper'
require "factories"
describe ItemsController do
	describe "GET requests" do
		before(:each) do
			@item = create(:item)
		end # before each
		it "should be successful" do
			get "show", :id => @item
			response.should be_success
		end # it
		it "should be successful" do
			get "index"
			response.should be_success
		end # it
		it "should be successful" do
			get "new"
			response.should be_success
		end # it
	end # Get requests
	
	describe "Post requests" do
		before(:each) do
			@item_data = FactoryGirl.generate( :item )
		end # before
		describe "success" do
			it "should create a new item" do
				lambda do
					post :create, :item => @item_data
				end.should change(Item, :count).by(1)
			end # it
			it "should have the same properities as the ones given" do
				post :create, :item => @item_data
				item = assigns(:item)
				@item_data.each do |key, val|
					item[key].should eq val
				end # item_data each
			end # it
			it "should render to the item show page" do
				post :create, :item => @item_data
				item = assigns(:item)
				response.should redirect_to item_path( item )
				flash[:success].should_not be_nil
			end # it
		end # success
	end # Post requests
	
	describe "Put requests" do
		before(:each) do
			@item = create(:item)
			@item_data = FactoryGirl.generate( :item )
		end # before each
		describe "success" do
			it "should allow a successful change" do
				put :update, :id => @item, :item => @item_data
				item = assigns(:item)
				@item_data.each do | key, val |
					item[key].should eq val
				end # item_data.each
			end # it
			it "should redirect to the edit page" do
				put :update, :id => @item, :item => @item_data
				response.should redirect_to edit_item_path( @item )
				flash[:success].should_not be_nil
			end # it
		end # success
		describe "odditiy changes" do
			before(:each) do
				@bids = (0..10).map { @item.bid( :offer => rand(999) ) }
			end # before each
			it "should clear out all the existing bids if an update is made" do
				put :update, :id => @item, :item => @item_data
				@item.bids.count.should eq 0
				@bids.each { |bid| Bid.find_by_id(bid).should be_nil }
				Item.find_by_id( @item.id ).should_not be_nil
			end # it
		end # oddity changes
	end # put requests
	describe "delete requests" do
		describe "success" do
			before(:each) do
				@item = create(:item)
				@bids = (1..10).map { @item.bid( :offer => rand(50) ) }
			end # before each
			it "should kill the item" do
				lambda do
					delete :destroy, :id => @item
				end.should change(Item, :count).by(-1)
			end # it
			it "should delete the right item" do
				delete :destroy, :id => @item
				Item.find_by_id( @item.id ).should be_nil
			end # it
			it "should delete all the associated bids" do
				lambda {delete :destroy, :id => @item }.should change(Bid, :count).by(-10)
			end # it
			it "should delete the right bids" do
				delete :destroy, :id => @item
				Bid.where( :item_id => @item.id ).should be_empty
			end # it
			it "should redirect and display correct flash messages" do
				delete :destroy, :id => @item
				flash[:success].should_not be_nil
				response.should redirect_to root_path
			end # it
		end # success
	end # delete requests
end # ItemsController
