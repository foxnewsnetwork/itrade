# == Schema Information
#
# Table name: items
#
#  created_at  :datetime         not null
#  description :text
#  id          :integer          not null, primary key
#  quantity    :integer          default(0)
#  title       :string(255)      default("No title")
#  units       :string(255)      default("kg")
#  updated_at  :datetime         not null
#

class Item < ActiveRecord::Base
  attr_accessible :description, :quantity, :title, :units
  
  has_many :bids
  
  def bid( data = nil )
  	offer = self.bids.new( data )
  	return offer if offer.save
  	return nil
  end # bid
end # Item
