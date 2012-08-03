require 'spec_helper'
require 'factories'
describe "ItemIndices" do
	before(:each) do
		@user = User.create Factory.next(:user)
		25.times { (@items ||= []) << Factory(:item, :user => @user) }
	end # before each
  [:plastic, :metal].each do |category|
  	[:hdpe, :ldpe].each do |type|
			describe "search" do
				subject { page }
				before(:each) do
					@steps = [ 
						lambda { visit items_path } ,
						lambda do 
							select(category.to_s, :from => "item_search_category")
							select(type.to_s, :from => "item_search_type")
							click_on("item_search_form_submit")
						end
					] # @steps
				end # before each
				(0..1).each do |k|
					describe "up to step #{k}" do
						before(:each) { (0..k).each { |j| @steps[j].call } }
						it { should_have_translations(html) }
					end # up to step
				end # each k
			end # search
		end # each type
  end # each category
end # ItemIndicies
