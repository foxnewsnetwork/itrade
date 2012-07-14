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
  
  has_many :bids, :dependent => :destroy
  
  # Hooks
  after_save :kill_all_bids
  
  def bid( data = nil )
  	offer = self.bids.new( data )
  	return offer if offer.save
  	return nil
  end # bid
  
  private
  	def kill_all_bids
  		# TODO : make the batch deletion less resource intensive
  		self.bids.each { |bid| bid.destroy }
  	end # kill_all_bids
end # Item
