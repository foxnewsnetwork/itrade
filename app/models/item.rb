# == Schema Information
#
# Table name: items
#
#  category    :string(255)      default("plastic"), not null
#  created_at  :datetime         not null
#  description :text
#  id          :integer          not null, primary key
#  location_id :integer
#  material    :string(255)
#  quantity    :integer          default(0)
#  title       :string(255)      default("No title")
#  units       :string(255)      default("kg")
#  updated_at  :datetime         not null
#  user_id     :integer
#

class Item < ActiveRecord::Base
  # attributes
  attr_accessible :description, :quantity, :title, :units, :location_id, :material, :category
  
  # Relationships
  has_many :bids, :dependent => :destroy
  has_many :elements, :dependent => :destroy
  belongs_to :user
  belongs_to :location
  
  # Hooks
  after_save :kill_all_bids
  
  # Custom modules
  include Location::Locateable
  
  def bid( data = nil )
  	offer = self.bids.new( data )
  	return offer if offer.save
  	return nil
  end # bid
  
  def suggested_prices
  	self.bids.where( :user_id => self.user_id )
  end # suggested_price
  
  private
  	def kill_all_bids
  		# TODO : make the batch deletion less resource intensive
  		self.bids.each { |bid| bid.destroy }
  	end # kill_all_bids
end # Item
