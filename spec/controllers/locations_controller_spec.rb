require 'spec_helper'
require 'factories'

# Note to future programmer:
# RSpec encourages concise code and fanciness.
# Fuck all that and just write code that works.
describe LocationsController do
	before(:each) do
		@user = User.create Factory.next(:user)
	end # before each
	
	[[Item, :item, :item_id]].each do |thing|
		describe "creation" do
			before(:each) do
				@location = Factory.next(:location)
				@call = lambda { |obj, location| post :create, thing[2] => obj, :location => location }
			end # before each
		
			describe "logged in" do
				login_user
				describe "correct user" do
					before(:each) do
						@item = Factory(thing[1], :user => @current_user)
					end # before each
					it "should create a new location" do
						lambda do
							@call.call @item, @location
						end.should change(Location, :count).by(1)
					end # it
					it "should be linked to the new location" do
						@call.call @item, @location
						thing[0].find(@item).location.should_not be_nil
					end # it
					it "should redirect correctly and have a flash" do
						@call.call @item, @location
						response.should redirect_to @item
						flash[:success].should_not be_nil
					end # it
				end # correct
			
				describe "incorrect user" do
					before(:each) do
						@item = Factory(thing[1], :user => @user )
					end # before each
					it "should not change anything" do
						lambda { @call.call @item, @location }.should_not change(Location, :count)
					end # it
					it "should not change items either" do
						lambda { @call.call @item, @location }.should_not change(@item, :location)
					end # it
					it "should have proper flash and redirect" do
						@call.call @item, @location
						response.should redirect_to @item
						flash[:error].should_not be_nil
					end # it
				end # incorrect
			end # logged in
			describe "anonymous user" do
				before(:each) { @item = Factory( :item, :user => @user ) }
				it "should redirect and have flash" do
					@call.call @item, @location
					response.should redirect_to new_user_session_path
					flash[:notice].should_not be_nil
				end #it
			end # anonymous user
		end # creation
	end # each thing
	
	describe "creation" do
		before(:each) do
			@location = Factory.next(:location)
			@call = lambda { |item, location| post :create, :item_id => item, :location => location }
		end # before each
		
		describe "logged in" do
			login_user
			describe "correct user" do
				before(:each) do
					@item = Factory(:item, :user => @current_user)
				end # before each
				it "should create a new location" do
					lambda do
						@call.call @item, @location
					end.should change(Location, :count).by(1)
				end # it
				it "should be linked to the new location" do
					@call.call @item, @location
					Item.find(@item).location.should_not be_nil
				end # it
				it "should redirect correctly and have a flash" do
					@call.call @item, @location
					response.should redirect_to @item
					flash[:success].should_not be_nil
				end # it
			end # correct
			
			describe "incorrect user" do
				before(:each) do
					@item = Factory(:item, :user => @user )
				end # before each
				it "should not change anything" do
					lambda { @call.call @item, @location }.should_not change(Location, :count)
				end # it
				it "should not change items either" do
					lambda { @call.call @item, @location }.should_not change(@item, :location)
				end # it
				it "should have proper flash and redirect" do
					@call.call @item, @location
					response.should redirect_to @item
					flash[:error].should_not be_nil
				end # it
			end # incorrect
		end # logged in
		describe "anonymous user" do
			before(:each) { @item = Factory( :item, :user => @user ) }
			it "should redirect and have flash" do
				@call.call @item, @location
				response.should redirect_to new_user_session_path
				flash[:notice].should_not be_nil
			end #it
		end # anonymous user
	end # creation
	
	describe "deletion" do
		before(:each) do
			@location = Factory(:location)
			@delete = lambda { |item| delete :destroy, :item_id => item, :id => item.location }
		end # before each
		describe "logged in" do
			login_user
			describe "correct" do
				before(:each) do 
					@item = Factory(:item, :user => @current_user) 
					@item.at @location
				end
				it "should null the location_id" do
					@delete.call @item
					Item.find(@item).location.should be_nil
				end # it
				it "should redirect and show flash" do
					@delete.call @item
					response.should redirect_to @item
					flash[:success].should_not be_nil
				end # it
			end # correct
			describe "incorrect" do
				before(:each) do
					@item = Factory(:item, :user => @user )
					@item.at @location
				end # before each
				it "should not do anything" do
					lambda do
						@delete.call @item
					end.should_not change(Item.find(@item), :location)
				end # it
				it "should show flash and redirect" do
					@delete.call @item
					response.should redirect_to @item
					flash[:error].should_not be_nil
				end # it
			end # incorrect
		end # logged in
		describe "anonymous" do
			before(:each) do
				@item = Factory(:item, :user => @user)
				@item.at @location
			end # before each
			it "should not change anything" do
				lambda { @delete.call @item }.should_not change(Item.find(@item), :location)
			end # it
			it "should show flash and redirect" do
				@delete.call @item
				response.should redirect_to new_user_session_path
				flash[:notice].should_not be_nil
			end # it
		end # anonymous
	end # deletion
	
	describe "put updates" do
		it "SHOULD HAVE TEST TO TEST THIS SECIONT!"
	end # put updates
end # LocationsController
