require 'spec_helper'
require "factories"
describe ElementsController do
	include ActionDispatch::TestProcess
	describe "create" do
		before(:each) do
			@element = Factory.next(:element)
			@user = User.create Factory.next( :user )
			@item2 = Factory(:item, :user => @user)
		end # before ach
		describe "logged in" do
			login_user
			before(:each) do
				@item = Factory(:item, :user => @current_user)
			end # 	before each
			it "should allow a successful creation" do
				lambda do
					post :create, :item_id => @item, :element => @element
				end.should change(Element, :count).by(1)
			end # it
			it "should have the correct data" do
				post :create, :item_id => @item, :element => @element
				element = Element.last
				Item.find_by_id(@item).elements.should include element
			end # it
			it "should redirect to items" do
				post :create, :item_id => @item, :element => @element
				response.should redirect_to item_path @item
				flash[:success].should_not be_nil
			end # it
			it "should not do anything" do
				lambda do
					post :create, :item_id => @item2, :element => @element
				end.should_not change(Element, :count)
			end # it
			it "should redirect to item path" do
				post :create, :item_id => @item2, :element => @element
				response.should redirect_to item_path @item2
				flash[:notice].should_not be_nil
			end # it
		end # logged in
		describe "anonymous user" do
			it "should not change anything" do
				lambda do
					post :create, :item_id => @item2, :element => @element
				end.should_not change(Element, :count)
			end # it
			it "should redirect and show flash" do
				post :create, :item_id => @item2, :element => @element
				response.should redirect_to new_user_session_path
				flash[:notice].should_not be_nil
			end # it
		end # anonymous
	end # create
	describe "delete" do
		before(:each) do
			@user = User.create Factory.next(:user)
			@item = Factory(:item, :user => @user )
			@element = Factory( :element, :item => @item )
		end # before each
		describe "logged in" do
			login_user
			before(:each) do
				@item2 = Factory(:item, :user => @current_user )
				@element2 = Factory( :element, :item => @item2 )
			end # before each
			it "should successfully delete" do
				lambda do
					delete :destroy, :item_id => @item2, :id => @element2
				end.should change(Element, :count).by(-1)
			end # it
			it "should have deleted the correct guy" do
				@item2.elements.should include @element2
				delete :destroy, :item_id => @item2, :id => @element2
				Item.find_by_id(@item2).elements.should_not include @element2
				Element.find_by_id( @item2.id ).should be_nil
			end # it
			it "should display flash and redirect to item" do
				delete :destroy, :item_id => @item2, :id => @element2
				response.should redirect_to item_path @item2
				flash[:success].should_not be_nil
			end # it
			it "should not delete other people's stuff" do
				lambda do
					delete :destroy, :item_id => @item, :id => @element
				end.should_not change( Element, :count )
			end # it
			it "should redirect and show flash" do
				delete :destroy, :item_id => @item, :id => @element
				response.should redirect_to item_path @item
				flash[:error].should_not be_nil
			end # it
			it "should not delete what is not there" do
				lambda do
					delete :destroy, :item_id => @item, :id => @element2
				end.should_not change(Element, :count)
			end # it
		end # logged in
		describe "anonymous" do
			it "should not change anything" do
				lambda do
					delete :destroy, :item_id => @item, :id => @element
				end.should_not change(Element, :count)
			end # it	
			it "should redirect and show flash" do
				delete :destroy, :item_id => @item, :id => @element
				response.should redirect_to new_user_session_path
				flash[:notice].should_not be_nil
			end # it
		end # anonymous
	end # delete
end # ElementsController
