# == Schema Information
#
# Table name: <%= singular_name %>_bids
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  <%= singular_name %>_id    :integer          not null
#  price      :decimal          default(0.0)
#  units      :string(255)      default("USD")
#  updated_at :datetime         not null
#

class Bid < ActiveRecord::Base
  # Attributes
  attr_accessible :price, :units
  
  # Relationships
  belongs_to :<%= singular_name %>
  
  
  
  def offer
  	price
  end # price
  
  def offer=(p)
  	price = price
  end # price
  
  
end # Bid
