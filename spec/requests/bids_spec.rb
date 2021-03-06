require 'spec_helper'
require 'factories'

describe "Bids" do
	before(:each) do
		@destination = Factory(:port)
		@middle = Factory(:port)
		@origination = Factory(:yard)
		@seller = Factory(:user)
		@item = Factory(:item, :user => @seller)
		@item.at @origination
		@transport = { 
			:truck => Factory(:truck).from(@origination).to(@middle) ,
			:ship => Factory(:ship).from(@middle).to(@destination)
		} # transport
		@service = Factory(:service)
		@user_data = Factory.next(:user)
		@user = User.create @user_data
		visit root_path
		fill_in "login_user_email", :with => @user_data[:email]
		fill_in "login_user_password", :with => @user_data[:password]
		click_on "submit-login-button"
		visit item_path( @item )
	end # before each
	it { should_have_translations( page.html ) }
	describe "starting a bid" do
		before(:each) do
			click_on "new_item_bid_link"
		end # before each
		it { should_have_translations( page.html ) }
		describe "fill in" do
			before(:each) do
				fill_in "bid[offer]", :with => rand(23433)
				select "pounds", :from => "bid_units"
				select "CNF", :from => "bid_shipping"
				select @destination.city + "-" + @destination.code, :from => "port_id_select_tag"
				[:truck, :ship].each do |a|
					select @transport[a].company, :from => "transportation_select_#{a}_id"
				end # each a
				check "service[#{@service.id}]"
			end # before each
			{ Bid => 1, Location => 0, Auxiliary => 3, Ship => 0, Truck => 0, Service => 0 }.each do |thing, amount|
				it "should create #{amount} #{thing.to_s}" do
					if amount > 0
						expect do
							click_on "submit-new_bid-button"
						end.to change(thing, :count).by(amount)
					else
						expect do
							click_on "submit-new_bid-button"	
						end.not_to change(thing, :count)
					end # if amount > 0
				end # it
			end # each model amount
			describe "landing" do
				before(:each) do
					click_on "submit-new_bid-button"
				end # before each
				it { should_have_translations( page.html ) }
			end # landing
		end # fill in
	end # starting a bid
end # Bids
