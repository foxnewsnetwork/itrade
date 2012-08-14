# == Schema Information
#
# Table name: targets
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  t_id       :integer
#  t_type     :string(255)
#  updated_at :datetime         not null
#

require 'spec_helper'
require 'factories'
describe Target do
  describe "relationships" do
  	before(:each) do
  		4.times do 
  			[:port, :yard].each do |thing|
  				((@locations ||= {})[thing] ||= []) << Factory(thing)
  			end # each thing
  		end # 4 times
  		@seller = Factory(:user)
  		@buyer = Factory(:user)
  		@item = Factory(:item, :user => @seller)
  		@bid = Factory(:bid, :item => @item, :user => @buyer)
  	end # before each
  	[:port, :yard].each do |thing|
			describe thing.to_s do
				it "should create an target" do
					expect do
						@bid.at @locations[thing][rand(4)]
					end.to change(Target, :count).by(1)
				end # it
				it "should duck correctly" do
					@bid.at @locations[thing][rand(4)]
					Bid.find_by_id(@bid).at.class.to_s.downcase.should eq thing.to_s.singularize
				end # it
				it "should have the right data" do
					@bid.at @locations[thing].first
					[:id, :city].each do |field|
						Bid.find_by_id(@bid).at[field].should eq @locations[thing].first[field]
					end # each field
				end # it
			end # thing.to_s
  	end # each thing
  end # relationships	
end # Target
