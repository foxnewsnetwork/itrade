# == Schema Information
#
# Table name: <%= plural_name %>
#
#  created_at  :datetime         not null
#  description :text
#  id          :integer          not null, primary key
#  quantity    :decimal          default(1.0)
#  title       :string(255)      default("No title")
#  units       :string(255)      default("unit")
#  updated_at  :datetime         not null
#

class <%= class_name %> < ActiveRecord::Base
  attr_accessible :description, :quantity, :title, :units
  
  has_many :<%= singular_name %>_bids, :dependent => :destroy
  
  # Hooks
  after_save :kill_all_<%= singular_name %>_bids
  
  def bid( data = nil )
  	offer = self.<%= singular_name %>_bids.new( data )
  	return offer if offer.save
  	return nil
  end # bid
  
  def <%= singular_name %>_bid( data = nil )
  	bid( data )
  end # <%= singular_name %>_bid
  
  private
  	def kill_all_<%= singular_name %>_bids
  		# TODO : make the batch deletion less resource intensive
  		self.<%= singular_name %>_bids.each { |bid| bid.destroy }
  	end # kill_all_<%= singular_name %>_bids
end # <%= class_name %>
