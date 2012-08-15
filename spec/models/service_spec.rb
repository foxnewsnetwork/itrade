# == Schema Information
#
# Table name: services
#
#  company     :string(255)      default("Tracago"), not null
#  created_at  :datetime         not null
#  description :string(255)      not null
#  expiration  :datetime
#  id          :integer          not null, primary key
#  price       :integer          default(0), not null
#  title       :string(255)      not null
#  updated_at  :datetime         not null
#

require 'spec_helper'
require 'factories'
describe Service do
  describe "Fatories" do
  	before(:each) do
  		@service = Factory(:service)
  	end # before each
  	it "SHOUL HAVE SOME TESTS HERE"
  end # factories
end # services
