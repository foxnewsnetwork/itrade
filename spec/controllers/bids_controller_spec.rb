require 'spec_helper'
require "factories"

describe BidsController do
	before(:each) do
		@user = User.create Factory.next( :user )
		@item = Factory(:item, :user => @user)
	end # before each
	describe "get" do
		login_user
		before(:each) do
			@bid = Factory(:bid, :user => @current_user, :item => @item)
		end # before each
		it "should be success" do
			get "show", :id => @bid
			response.should be_success
		end # it
	end # get
	describe "bid creation" do
		describe "success" do
			login_user
			before(:each) do
				@bid_data = Factory.next(:bid)
				@location_data = Factory.next(:location)
				@methods = { 
					:vanilla => lambda { post :create, :item_id => @item, :bid => @bid_data, :location => @location_data } ,
					:ajax => lambda { xhr :post, :create, :item_id => @item, :bid => @bid_data, :location => @location_data }
				} # methods
			end # before each
			[:vanilla, :ajax].each do |style|
				[Bid, Location].each do |target|
					it "should change the bid database" do
						@methods[style].should change(target, :count).by(1)
					end # it
				end # each target
				it "the item should be correctly linked" do
					@methods[style].call
					Bid.last.location.should_not be_nil
				end # it
			end # each style
			it "should be successful" do
				@methods[:vanilla].call
				response.should redirect_to @item
				flash[:success].should_not be_nil
			end # it
			it "should change the database" do
				lambda do
					@methods[:vanilla].call
				end.should change(Bid, :count).by(1)
			end # it
			it "should have the correct data" do
				@methods[:vanilla].call
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
					flash[:notice].should_not be_nil
				end # it
			end # failure
		end # deletion
	end # item creation
	
	describe "put updates" do
		before(:each) do
			@bid_data = Factory.next(:bid)
			@location_data = Factory.next(:location)
		end # before each
		context "When logged in" do
			login_user
			before(:each) do
				@bid = Factory(:bid, :user => @current_user, :item => @item)
			end # before each
			describe "correct user" do
				before(:each) do
					@methods = { 
						:ajax => lambda { xhr :put, :update, :item_id => @item, :id => @bid, :bid => @bid_data, :location => @location_data } ,
						:vanilla => lambda { put :update, :item_id => @item, :id => @bid, :bid => @bid_data, :location => @location_data }
					} # methods
				end # before each
				describe "existing location" do
					[:vanilla, :ajax].each do |style|
						describe "success in #{style.to_s}" do
							before(:each) { @bid.at Factory(:location) }
							it "should change the bid data" do
								@methods[style].call 
								Bid.find_by_id(@bid).offer.should eq @bid_data[:offer]
							end # it
							[:address, :city, :state, :country, :shipping, :zip].each do |field|
								it "should change the location data #{field}" do
									@methods[style].call
									Bid.find_by_id(@bid).location[field].should eq @location_data[field]
								end # it
							end # each field
						end # success 
					end # each style
				end # existing location
				describe "no location" do
					[:vanilla, :ajax].each do |style|
						describe "success in #{style.to_s}" do
							it "should change the bid data" do
								@methods[style].call
								Bid.find_by_id(@bid).offer.should eq @bid_data[:offer]
							end # it
							it "should create a new location data" do
								@methods[style].should change(Location, :count).by(1)
							end # it
							[:address, :city, :state, :country, :shipping, :zip].each do |field|
								it "should match the #{field.to_s}" do
									@methods[style].call
									Bid.find_by_id(@bid).location[field].should eq @location_data[field]
								end # it
							end # each field
						end # success 
					end # each style
				end # no location
			end # correct user
			describe "wrong user" do
				before(:each) do 
					@user = User.create Factory.next(:user)
					@item2 = Factory(:item, :user => @user )
					@bid2 = Factory(:bid, :item => @item2, :user => @user)
					@methods = { 
						:ajax => lambda { xhr :put, :update, :item_id => @item2, :id => @bid2, :bid => @bid_data, :location => @location_data } ,
						:vanilla => lambda { put :update, :item_id => @item2, :id => @bid2, :bid => @bid_data, :location => @location_data }
					} # methods
				end # before each
				[:vanilla, :ajax].each do |style|
					it "should not change anything" do
						[@user, @item2, @bid2].each do |target|
							@methods[style].call
							target.should eq target.class.find_by_id(target.id)
						end # each target
					end # it
					it "should have a proper flash" do
						@methods[style].call
						flash[:error].should_not be_nil
					end # it
				end # each style
			end # wrong user
		end # "when logged in"
		context "when anonymous" do
			before(:each) do 
				@user = User.create Factory.next(:user)
				@item2 = Factory(:item, :user => @user )
				@bid2 = Factory(:bid, :item => @item2, :user => @user)
				@methods = { 
					:ajax => lambda { xhr :put, :update, :item_id => @item2, :id => @bid2, :bid => @bid_data, :location => @location_data } ,
					:vanilla => lambda { put :update, :item_id => @item2, :id => @bid2, :bid => @bid_data, :location => @location_data }
				} # methods
			end # before each
			[:vanilla, :ajax].each do |style|
				it "should not change anything" do
					[@user, @item2, @bid2].each do |target|
						@methods[style].call
						target.should eq target.class.find_by_id(target.id)
					end # each target
				end # it
				it "should have a proper flash" do
					@methods[style].call
					flash[:error].should_not be_nil
				end # it
			end # each style
		end # when anonymous
		
	end # put updates
end # BidsController
