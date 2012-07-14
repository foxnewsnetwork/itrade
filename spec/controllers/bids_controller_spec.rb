require 'spec_helper'
require "factories"
describe BidsController do
	before(:each) do
		@item = create(:item)
	end # before each
	describe "creation" do
		before(:each) do
			@bid_data = { :offer => rand(50) }
		end # before each
		it "should change the database" do
			lambda do 
				post :create, :item_id => @item.id, :bid => @bid_data
			end.should change(Bid, :count).by(1)
		end # it
		it "should redirect to the item page and show a flash message" do
			post :create, :item_id => @item.id, :bid => @bid_data
			flash[:success].should_not be_nil
			response.should redirect_to item_path @item
		end # it
	end # creation
	
	describe "destroy" do
		describe "success" do
			before(:each) do
				@bid = @item.bid( :offer => rand(23423) )
			end # before each
			it "should destroy the bid" do
				delete :destroy, :item_id => @item.id, :id => @bid.id
				Bid.find_by_id(@bid.id).should be_nil
			end # it
			it "should show a flash message and redirect to item" do
				delete :destroy, :item_id => @item.id, :id => @bid.id
				response.should redirect_to item_path @item
				flash[:success].should_not be_nil
			end # it
		end # it
	end # destroy
end # BidsController
