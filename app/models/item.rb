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
#  user_id     :integer
#

class Item < ActiveRecord::Base
  # attributes
  attr_accessible :description, :quantity, :title, :units
  
  # Relationships
  has_many :bids, :dependent => :destroy
  has_many :elements, :dependent => :destroy
  belongs_to :user
  
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
