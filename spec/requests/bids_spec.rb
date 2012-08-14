require 'spec_helper'
require 'factories'

describe "Bids" do
	before(:each) do
		@destination = Factory(:port)
		@origination = Factory(:yard)
		@seller = Factory(:user)
		@item = Factory(:item, :user => @seller)
		@item.at @origination
		[:ship, :truck].each do |a|
			(@transport ||= { })[a] = Factory(a).from(@origination).to(@destination)
		end # each a
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
				select @destination.city + "-" + @destination.code, :from => "port_id"
				check "truck[id]"
				select @service.title, :from => "service_id"
				select @transport[:ship].company, :from => "ship_id"
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
