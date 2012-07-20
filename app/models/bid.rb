# == Schema Information
#
# Table name: bids
#
#  created_at  :datetime         not null
#  id          :integer          not null, primary key
#  item_id     :integer          not null
#  location_id :integer
#  offer       :integer          default(0)
#  paydate     :datetime
#  paytype     :string(255)
#  units       :string(255)      default("USD")
#  updated_at  :datetime         not null
#  user_id     :integer
#

class Bid < ActiveRecord::Base
  # Attributes
  attr_accessible :item_id, :offer, :units, :location_id
  
  # Relationships
  belongs_to :item
  belongs_to :user
  belongs_to :location
  
  # Custom modules
  include Location::Locateable
  
  def price
  	offer
  end # price
  
  def price=(p)
  	offer = price
  end # price
  
  
end # Bid
