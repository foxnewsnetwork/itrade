# == Schema Information
#
# Table name: locations
#
#  address    :string(255)
#  city       :string(255)
#  country    :string(255)
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  name       :string(255)
#  state      :string(255)
#  updated_at :datetime         not null
#  zip        :string(255)
#

class Location < ActiveRecord::Base
	# attributes
  attr_accessible :address, :city, :country, :name, :state, :zip
  
  # Relationships
  has_many :items
  has_many :bids
  
  # Validations
  {
  	:address => /^\d+\s+.+$/,
  	:city => /^[\D\s-]+$/,
  	:country => /^[\D\s-]+$/,
  	:state => /^[\D\s-]+$/,
  	:zip => /^(\d){5}(-(\d){4})*$/
	}.each do |field, regex|
	  validates field, :presence => true, :format => { :with => regex }
	end # presence validation
	
	# Callbacks
	before_save :p_process_name
		
	# Duck-typing yay!
	def has( item = nil )
		if item.nil?
			self.items
		else
			item.location_id = self.id
			self.items if item.save
		end
	end # has
	
	private
		def p_process_name
			self.name = self.name.strip.downcase.squeeze(" ").gsub( /(\W|\s|\d|_)/, "" )
		end # p_process_name
	
	module Locateable 
		def at( place = nil )
			self.location_id = place.id unless place.nil?
			self.location if self.save
		end # at
		def at!( place = nil )
			self.location_id = place.id unless place.nil?
			self.save!
			self.location
		end # at!
	end # Locateable
end # Location
