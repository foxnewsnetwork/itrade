# == Schema Information
#
# Table name: auxiliaries
#
#  bid_id     :integer          not null
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  s_id       :integer          not null
#  s_type     :string(255)      not null
#  updated_at :datetime         not null
#

require 'spec_helper'
require 'factories'
describe Auxiliary do
  describe "relationships" do
  	before(:each) do
  		[:ship, :truck].each do |transport|
  			(@transport ||= {})[transport] = Factory(transport, :origination => Factory(:location), :destination => Factory(:location) )
  		end # each
  		@transport[:service] = Factory(:service)
  		@seller = User.create Factory.next(:user)
  		@buyer = User.create Factory.next(:user)
  		@item = Factory(:item, :user => @seller)
  		@item.at Factory(:location)
  		@bid = Factory(:bid, :item => @item, :user => @buyer)
  		@bid.at Factory(:location)
  	end # before each
  	
  	[:ship, :truck, :service].each do |thing|
  		it "should respond to #{thing}" do
  			@bid.should respond_to thing unless thing == :service
  			@bid.should respond_to :services
  		end # it
  		it "should have the #{thing}" do
  			@bid.has @transport[thing]
  			unless thing==:service
  				@bid.method(thing).call.should eq @transport[thing]
  			else
  				@bid.method(thing.to_s.pluralize.to_sym).call.first.should eq @transport[thing]
  			end # if service
  		end # it
  		it "should change the database" do
  			expect do
  				@bid.has @transport[thing]
  			end.to change(Auxiliary, :count).by(1)
  		end # it
  	end # each thing
  end # relationships
end # Auxiliary
