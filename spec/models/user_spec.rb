# == Schema Information
#
# Table name: users
#
#  address                :string(255)      not null
#  city                   :string(255)      not null
#  company                :string(255)      default(""), not null
#  country                :string(255)      default(""), not null
#  created_at             :datetime         not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  id                     :integer          not null, primary key
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0)
#  state                  :string(255)      default(""), not null
#  updated_at             :datetime         not null
#  zip                    :string(255)      default(""), not null
#

require 'spec_helper'
require "factories"
describe User do
  describe "Factories" do
  	it "should be valid" do
  		FactoryGirl.generate( :user ).should_not be_nil
  	end # it
  	it "should create a user" do
  		user = create(:user)
  		user.should_not be_nil
  	end # it
  end # factories
end
