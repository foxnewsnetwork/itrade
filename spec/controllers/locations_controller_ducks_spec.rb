require 'spec_helper'
require 'factories'

describe LocationsController do	
	describe "logged in" do
		create_product
		describe "success" do
			before(:each) do
				@ducks = {:user_id => @myuser, :item_id => @item, :bid_id => @bid}
				@create = lambda { |key, duck| post :create, key => duck, :location => @location_data }
				@destroy = lambda { |key, duck| delete :destroy, key => duck, :id => duck.location.id }
			end # before each
			{ :user_id => 'user',:item_id => 'item',:bid_id => 'bid' }.each do |key, model|
				describe "destructions" do
					before(:each) do
						@location = Factory(:location)
						@ducks[key].at @location
					end # before each
					it "should delete the location when #{model}" do
						lambda do
							@destroy.call key, @ducks[key]
						end.should change(Location, :count).by(-1)
					end # it
					it "should unlink the #{model}" do
						@destroy.call key, @ducks[key]
						duck = @ducks[key].class.find_by_id @ducks[key]
						duck.location.should be_nil
					end # it
					it "should redirect to #{model}" do
						@destroy.call key, @ducks[key]
						response.should redirect_to @ducks[key]
					end # it
					it "should have a flash message" do
						@destroy.call key, @ducks[key]
						flash[:success].should_not be_nil
					end # it
				end # desctructions
				it "should destroy the old location if there is one" do
					location = Factory( :location )
					@ducks[key].at location
					lambda do
						@create.call key, @ducks[key]
					end.should_not change(Location, :count)
				end # it
				it "should create the location when the duck is a #{model}" do
					lambda do
						@create.call key, @ducks[key]
					end.should change(Location, :count).by(1)
				end # it	
				it "should pin the location to the #{model}" do
					@create.call key, @ducks[key]
					duck = @ducks[key].class.find_by_id @ducks[key]
					duck.location.should_not be_nil
				end # it
				it "should have the correct data #{model}" do
					@create.call key, @ducks[key]
					duck = @ducks[key].class.find_by_id @ducks[key]
					@location_data.each do |k,v|
						duck.location[k].should == v unless k == :name
						duck.location[k].strip.downcase.gsub(/(\W|\s)/, "") if k == :name
					end # @location_data
				end # it
				it "should redirect to #{model} show" do
					@create.call key, @ducks[key]
					response.should redirect_to @ducks[key]
				end # it
				it "should have a proper flash" do
					@create.call key, @ducks[key]
					flash[:success].should_not be_nil
				end # it
				describe "no permission" do
					before(:each) do
						@other_ducks = { :user_id => @another_user, :item_id => @another_item, :bid_id => @another_bid }
						@calls = { :create => @create, :destroy => @destroy }
					end # before each
					{:create => "create", :destroy => "destroy"}.each do |verb, v|
						before(:each) do
							@other_ducks[key].at Factory(:location) if verb == :destroy
						end # it
						it "should #{v} locations for #{model}" do
							lambda do
								@calls[verb].call key, @other_ducks[key]
							end.should_not change(Location, :count)
						end # it
						it "should not #{v} anything to #{model}" do
							lambda do
								@calls[verb].call key, @other_ducks[key]
							end.should_not change(@other_ducks[key].class.find_by_id( @other_ducks[key]), :location)
						end # it
						it "should have proper flash" do
							@calls[verb].call key, @other_ducks[key]
							flash[:error].should_not be_nil
						end # it
					end # each verb
				end # no permission
			end # each key model
		end # success
	end # logged in
	
	describe "anonymous" do
		create_product(:anonymous)
		before(:each) do
			@ducks = {:user_id => @myuser, :item_id => @item, :bid_id => @bid}
			@create = lambda { |key, duck| post :create, key => duck, :location => @location_data }
			@destroy = lambda { |key, duck| delete :destroy, key => duck, :id => duck.location.id }
			@calls = { :create => @create, :destroy => @destroy }
		end # before each
		{ :user_id => 'user',:item_id => 'item',:bid_id => 'bid' }.each do |key, model|
			{ :create => "create", :destroy => "destroy" }.each do |verb, faggot|
				before(:each) do
					@ducks[key].at Factory(:location) if verb == :destroy
				end # before each
				it "should not create any locations when #{model}" do
					lambda do
						@calls[verb].call key, @ducks[key]
					end.should_not change(Location, :count)
				end # it
				it "should not pin anything to #{model}" do
					lambda do
						@calls[verb].call key, @ducks[key]
					end.should_not change(@ducks[key], :location)
				end # it
				it "should redirect to #{model}" do
					@calls[verb].call key, @ducks[key]
					response.should redirect_to new_user_session_path
				end # it
				it "should have proper flash" do
					@calls[verb].call key, @ducks[key]
					flash[:notice].should_not be_nil
				end # it
			end # each verb
		end # each key model
	end # anonymous
end # LocationsController
