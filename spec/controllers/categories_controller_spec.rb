require 'spec_helper'
require 'factories'

describe CategoriesController do
	describe "index" do
		before(:each) do
			10.times do
				(@roots ||= []) << Factory(:category)
				@methods = { 
					:vanilla => lambda { get "index", :format => "json" } ,
					:ajax => lambda { xhr :get, "index", :format => "json" }
				} # methodds
			end # 10 times
		end # before each
		[:vanilla, :ajax].each do |style|
			describe "when #{style}" do
				before(:each) { @methods[style].call }
				it { response.should be_success }
				it "should present the roots" do
					data = MultiJson.load(response.body)
					@roots.each do |root|
						match = false
						data['categories'].each do |root_data|
							if root_data[:id] == root[:id]
								if root_data[:name] == root[:name]
									match = true
								end # match name
							end # match id
						end # each root_data
					end # each root
				end # it
			end # when style
		end # each style
	end # index
	describe "show" do
		before(:each) do
			@root = Factory(:category)
			10.times { (@children ||= []) << @root.spawn( Factory.next(:category) ) }
			@methods = { 
				:vanilla => lambda { get :show, :id => @root.id, :format => "json" }, 
				:ajax => lambda { xhr :get, :show, :id => @root.id, :format => "json" } 
			}
		end # before each
		[:vanilla, :ajax].each do |style|
			describe "when #{style}" do
				before(:each) { @methods[style].call }
				it "should be successful" do
					response.should be_success
				end # it
				it "should have the correct data" do
					data = MultiJson.load( response.body )
					[:id, :name, :parent_id].each do |key|
						data[key.to_s].should eq @root[key]
					end # each key
					data["children"].each do |child|
						match = false
						@children.each do |kid|
							if child["id"] == kid.id
								if child["name"] == kid.name
									match = true
								end # if match name
							end # if match id
						end # each kid
						match.should be_true
					end # each child
				end # it
			end # when style
		end # each style
	end # show
	describe "logged in admin" do
		login_admin
		before(:each) { @root = Factory(:category) }
		describe "create" do
			before(:each) do 
				(@data ||= []) << Factory.next(:category)	<< Factory.next(:category).merge( :parent_id => @root.id )
				@methods = { 
					:vanilla => lambda { |d| post :create, :category => d } ,
					:ajax => lambda { |d| xhr :post, :create, :category => d }
				} # methods
			end # before each
			[:vanilla, :ajax].each do |style|
				2.times do |k|
					it "should change the database when in #{style}" do
						expect { @methods[style].call(@data[k]) }.to change(Category, :count).by(1)
					end # it
				end # times k
				
				it "should be properly related" do
					@methods[style].call(@data.last)
					Category.find_by_id(@root).children.should include assigns(:category)
					assigns(:category).parent.should eq @root
				end # it
				
			end # each style
		end # create
		describe "destroy" do
			before(:each) do
				@child = Factory(:category, :parent => @root )
				@methods =  {
					:vanilla => lambda { |d| delete :destroy, :id => d.id } ,
					:ajax => lambda { |d| xhr :delete, :destroy, :id => d.id }
				} # methods
			end # before each
			[:vanilla, :ajax].each do |style|
				it "should change the database" do
					expect { @methods[style].call( @child ) }.to change(Category, :count).by(-1)		
				end # it
				it "should kill the right one" do
					@methods[style].call( @child )
					Category.find_by_id(@child).should be_nil
				end # it
				it "should really change the database" do
					expect { @methods[style].call( @root) }.to change(Category, :count).by(-2)
				end # it
				it "should kill the whole house" do
					@methods[style].call( @root )
					[@child, @root].each do |node|
						Category.find_by_id(node.id).should be_nil
					end # node
				end # it
			end # each style
		end # destroy
	end # logged in admin
	
	describe "anything else" do
		{ :user => lambda { login_user }, :anonymous => lambda { 0 } }.each do |account, operation|
			describe "logged in as #{account}" do
				operation.call
				before(:each) do
					@methods = [
						lambda { post :create, Factory.next(:random_hash) } ,
						lambda { xhr :post, :create, Factory.next(:random_hash) } ,
						lambda { delete :destroy, { :id => rand(444) }.merge( Factory.next(:random_hash) ) } ,
						lambda { xhr :delete, :destroy, { :id => rand(444) }.merge( Factory.next(:random_hash) ) }
					] # methods
				end # before each
				4.times do |k|
					it "should show a flash" do
						@methods[k].call
						flash[:error].should_not be_nil
					end # it
					it "should redirect to root" do
						@methods[k].call
						response.should redirect_to root_path
					end # it
					it "should not change anything" do
						@methods[k].should_not change(Category, :count)
					end # it
				end # 4 times
			end # logged in as
		end # each account operation
	end # anything else
end # CategoriesController
