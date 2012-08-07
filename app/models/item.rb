# == Schema Information
#
# Table name: items
#
#  category      :string(255)      default("plastic"), not null
#  created_at    :datetime         not null
#  description   :text
#  id            :integer          not null, primary key
#  location_id   :integer
#  material      :string(255)
#  material_type :string(255)
#  quantity      :integer          default(0)
#  title         :string(255)      default("No title")
#  units         :string(255)      default("kg")
#  updated_at    :datetime         not null
#  user_id       :integer
#

class Item < ActiveRecord::Base
  # attributes
  attr_accessible :description, :quantity, :title, :units, :location_id, :material, :category, :material_type
  
  # Relationships
  has_many :statuses, :dependent => :destroy
  has_many :bids, :dependent => :destroy
  has_many :elements, :dependent => :destroy
  belongs_to :user
  belongs_to :location
  
  # Hooks
  after_save :prepare_auxiliaries
  after_create :create_status
  
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
  
  def sold_to(user=nil)
  	if user.nil?
  		User.find_by_id( self.statuses.find_by_name( "sold" ).effect )
  	else
  		status = self.statuses.find_by_name( "sold" )
  		if status.nil?
  			self.statuses.create( :name => "sold", :effect => user.id.to_s )
  		else
	  		status.update_attributes( :effect => user.id.to_s )
	  	end # if sold
	  	self
	  end # no user
  end # sold_to
  
  def recurring(days=nil)
  	if days.nil?
  		self.statuses.find_by_name( "recurring" ).effect.to_i.seconds
  	else
  		status = self.statuses.find_by_name( "recurring" )
  		status.update_attributes( :effect => days.to_s ) unless status.nil?
  		self.statuses.create( :name => "recurring", :effect => days.to_s ) if status.nil?
  		self
  	end # no days
  end # recurring
  
  private
  	def prepare_auxiliaries
  		# TODO : make the batch deletion less resource intensive
  		# NOTE: Do we really even need to do this?
  		# self.bids.each { |bid| bid.destroy }
  		
  		# Check the status
  		ready_flag = true
  		Item.attr_accessible[:default].each do |attribute|
  			unless attribute == "" || attribute == "location_id"
					ready_flag = false if self[attribute].nil?
				end # unless bad attributes
  		end # each attribute
  		if ready_flag
				incomplete = self.statuses.find_by_name("incomplete")
				incomplete.destroy unless incomplete.nil?
				self.statuses.create( :name => "ready" ) if self.statuses.find_by_name("ready").nil?
  		else
  			ready = self.statuses.find_by_name "ready"
  			ready.destroy unless ready.nil?
  			self.statuses.create( :name => "incomplete" ) if self.statuses.find_by_name("incomplete").nil?
  		end # if ready
  	end # kill_all_bids
  	
  	def create_status
  		self.statuses.create( :name => "incomplete" )
  	end # create_status
end # Item
