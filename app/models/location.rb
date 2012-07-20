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
  	:name => /^.+$/,
  	:state => /^[\D\s-]+$/,
  	:zip => /^\d{5}$/
	}.each do |field, regex|
	  validates field, :presence => true, :format => { :with => regex }
	end # presence validation
	validates :name, :uniqueness => { :case_sensitive => false }
	
	# Callbacks
	before_save :p_process_name
	
	# Duck-typing yay!
	def has(item)
		item.location_id = self.id
		item.save
	end # has
	
	private
		def p_process_name
			self.name = self.name.strip.downcase.squeeze(" ").gsub( /(\W|\s|\d|_)/, "" )
		end # p_process_name
	
	module Locateable
		def at( location )
			self.location_id = location.id
			self.save
		end # at
	end # Locateable
end # Location
