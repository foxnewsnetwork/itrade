# == Schema Information
#
# Table name: bids
#
#  created_at  :datetime         not null
#  id          :integer          not null, primary key
#  item_id     :integer          not null
#  location_id :integer
#  maw         :integer
#  offer       :integer          default(0)
#  paydate     :datetime
#  paytype     :string(255)
#  units       :string(255)      default("USD")
#  updated_at  :datetime         not null
#  user_id     :integer
#

class Bid < ActiveRecord::Base
  # Attributes
  attr_accessible :item_id, :offer, :units, :location_id, :paytype
  
  # Relationships
  belongs_to :item
  belongs_to :user
  belongs_to :location
  has_many :auxiliaries 
  
  # Custom modules
  include Location::Locateable
  
  def price
  	offer
  end # price
  
  def price=(p)
  	offer = price
  end # price
  
 	def truck
 		transport = transports("truck")
  	transport.first.retrieve unless transport.nil?
 	end # truck
 	
  def ship
  	transport = transports("ship")
  	transport.first.retrieve unless transport.nil?
  end # ship
  
  def services
  	Service.where( :id => (self.auxiliaries.map { |aux|	aux.s_id }) )
  end # service
  
  def has(duck)
  	self.auxiliaries.new.establish( duck ).save
  end # has
  
  private
  	def transports(thing)
  		transport = self.auxiliaries.where(:s_type => thing)
  	end # transport
end # Bid
