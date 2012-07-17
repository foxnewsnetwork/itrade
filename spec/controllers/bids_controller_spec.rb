require 'spec_helper'
require "factories"

describe BidsController do
	before(:each) do
		@user = User.create Factory.next( :user )
		@item = Factory(:item, :user => @user)
	end # before each
	describe "bid creation" do
		describe "success" do
			login_user
			before(:each) do
				@bid_data = { :offer => rand(999) }
			end # before each
			it "should be successful" do
				post :create, :item_id => @item, :bid => @bid_data
				response.should redirect_to item_path @item
				flash[:success].should_not be_nil
			end # it
			it "should change the database" do
				lambda do
					post :create, :item_id => @item, :bid => @bid_data
				end.should change(Bid, :count).by(1)
			end # it
			it "should have the correct data" do
				post :create, :item_id => @item, :bid => @bid_data
				bid = Bid.last
				bid.price.should eq @bid_data[:offer]
				bid.user.should eq @current_user
				bid.item.should eq @item
			end # it
		end # success
		describe "failure" do
			before(:each) do
				@bid_data = { :offer => rand(999) }
			end # before each
			it "should redirect and show flash" do
				post :create, :item_id => @item, :bid => @bid_data
				response.should redirect_to new_user_session_path
				flash[:notice].should_not be_nil
			end # it
			it "should not change anything" do
				lambda do
					post :create, :item_id => @item, :bid => @bid_data
				end.should_not change(Bid, :count)
			end # it
		end # failure
		
		describe "deletion" do
			before(:each) do
				@bid = @user.bid( { :offer => rand(555) }, @item.id )
			end # before each
			describe "success" do
				login_user
				before(:each) do
					@bid2 = @current_user.bid( { :offer => rand(235) }, @item.id )
				end # before each
				it "should destroy the fuck out of the bid" do
					lambda do
						delete :destroy, :item_id => @item, :id => @bid2
					end.should change(Bid, :count).by(-1)
				end # it
				it "should destroy the correct one" do
					delete :destroy, :item_id => @item, :id => @bid2
					Bid.find_by_id( @bid2 ).should be_nil
				end # it	
				it "should redirect to items" do
					delete :destroy, :item_id => @item, :id => @bid2
					response.should redirect_to item_path @item
					flash[:success].should_not be_nil
				end # it
				it "should not destroy other people's stuff" do
					delete :destroy, :item_id => @item, :id => @bid
					response.should redirect_to item_path @item
					flash[:error].should_not be_nil
				end # it
				it "should not change other people's stuff" do
					lambda do
						delete :destroy, :item_id => @item, :id => @bid
					end.should_not change(Bid, :count)
				end # it
			end # success
			describe "failure" do
				it "should not change anything" do
					lambda do
						delete :destroy, :item_id => @item, :id => @bid
					end.should_not change(Bid, :count)
				end # it
				it "should redirect to signin" do
					delete :destroy, :item_id => @item, :id => @bid
					response.should redirect_to new_user_session_path
					flash[:error].should_not be_nil
				end # it
			end # failure
		end # deletion
	end # item creation
	
end # BidsController
