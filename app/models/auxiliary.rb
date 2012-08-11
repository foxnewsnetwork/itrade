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

class Auxiliary < ActiveRecord::Base
  attr_accessible :bid_id, :s_id, :s_type
  
  # Relationships
  belongs_to :bid
  
  # Validations
  validates :s_type, :presence => true, :format => { :with => /^(ship|truck|service)$/ }
  [:s_id, :bid_id].each do |present|
  	validates present, :presence => present
  end # each present
  
  # Private static variables
  @@funstuff = { :ship => Ship, :truck => Truck, :service => Service }
  
  def retrieve
  	@@funstuff[self.s_type.to_sym].find_by_id( self.s_id )
  end # retrieve
  
  def establish( duck )
  	self.s_id = duck.id
  	self.s_type = duck.class.to_s.downcase
  	self
  end # establish
end # Auxiliary
