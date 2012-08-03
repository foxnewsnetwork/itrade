require 'spec_helper'
require "factories"
describe ItemsController do
	describe "index parameters" do
		before(:each) do
			@methods = {
				:vanilla => lambda { |c, t| get :index, :category => c, :type => t }, 
				:ajax => lambda { |c, t| xhr :get , :index, :category => c, :type => t }
			} # methods
			@user = User.create Factory.next(:user)
		end # before each
		[:plastic, :metal, :paper].each do |category|
			[:hdpe, :pp, :ldpe, :pet].each do |type|
				[ :vanilla, :ajax ].each do |style|
					context "categorized search for #{type} in #{category}" do
						subject { assigns(:items) }
						before(:each) do
							(1 + rand(7)).times do
								(@good_items ||= []) << Factory(:item, :user => @user, :category => category, :material_type => type)
								(@bad_items ||= []) << Factory(:item, 
									:user => @user, 
									:category => category == :paper ? :plastic : :paper, 
									:material_type => type == :hdpe ? :pp : :hdpe )
							end # 25 times
							@methods[style].call category, type
						end # before each
						it "should show all #{category} that are #{type}" do
							should eq @good_items
						end # it
						it "should not have anything else" do
							items = assigns(:items)
							@bad_items.each do |bad|
								items.should_not include bad
							end # each bad
						end # it
					end # categorized search
				end # each style
			end # each type
		end # each category
	end # index parameters

	describe "GET requests" do
		before(:each) do
			@user = User.create Factory.next(:user)
			@item = Factory(:item, :user => @user)
		end # before each
		it "should be successful" do
			get "show", :id => @item
			response.should be_success
		end # it
		it "should show a 404" do
			get "show", :id => 12380420937842937
			response.should render_template "layouts/application"
		end # it
		it "should be successful" do
			get "index"
			response.should be_success
		end # it
		it "should redirect to login" do
			get "new"
			response.should redirect_to new_user_session_path
			flash[:notice].should_not be_nil
		end # it
		it "should redirect to login" do
			get "edit", :id => @item
			response.should redirect_to new_user_session_path
			flash[:notice].should_not be_nil
		end # it
		describe "logged in" do
			login_user
			before(:each)do
				@myitem = Factory(:item, :user => @current_user)
			end # before each	
			it "should be successful" do
				get "new"
				response.should be_success
			end # it
			it "should be redirect" do
				get "edit", :id => @item
				response.should redirect_to item_path @item
				flash[:notice].should_not be_nil
			end # it
			it "should be successful" do
				get "edit", :id => @myitem
				response.should be_success
			end # it
		end # logged in
	end # Get requests
	
	describe "Post requests" do
		before(:each) do
			@item_data = Factory.next( :item )
		end # before
		describe "failure" do
			it "should redirect to user login" do
				post :create, :item => @item_data
				response.should redirect_to new_user_session_path
				flash[:notice].should_not be_nil
			end # it
			it "should not change anything" do
				lambda do
					post :create, :item => @item_data
				end.should_not change(Item, :count)
			end # it
		end # failure
		describe "success" do
			login_user
			before(:each) do
				@bad_data = @item_data.merge( :user_id => rand(20384203) )
			end # before each
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
			it "should belong to the right person" do
				post :create, :item => @item_data
				item = assigns(:item)
				User.find_by_id(@current_user).items.should include item
			end # it
		end # success
	end # Post requests
	
	describe "Put requests" do
		before(:each) do
			@item = Factory(:item)
			@item_data = Factory.next( :item )
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
				@item = Factory(:item)
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
