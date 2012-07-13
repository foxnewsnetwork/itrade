# == Schema Information
#
# Table name: bids
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  item_id    :integer          not null
#  offer      :integer          default(0)
#  units      :string(255)      default("USD")
#  updated_at :datetime         not null
#

class Bid < ActiveRecord::Base
  attr_accessible :item_id, :offer, :units
  
  belongs_to :item
  
  def price
  	offer
  end # price
  
  def price=(p)
  	offer = price
  end # price
end # Bid
