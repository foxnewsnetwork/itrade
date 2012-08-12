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
#  official   :boolean          default(FALSE), not null
#  shipping   :string(255)      default("EXWORKS"), not null
#  state      :string(255)
#  updated_at :datetime         not null
#  zip        :string(255)
#

class Location < ActiveRecord::Base
	# attributes
  attr_accessible :address, :city, :country, :name, :state, :zip, :shipping
  attr_accessor :official
  
  # Relationships
  has_many :items
  has_many :bids
  has_many :users
  
  # Validations
#  {
#  	:address => /^\d+\s+.+$/,
#  	:city => /^[\D\s-]+$/,
#  	:country => /^[\D\s-]+$/,
#  	:state => /^[\D\s-]+$/,
#  	:zip => /^(\d){5}(-(\d){4})*$/ ,
#  	:shipping => /^(EXWORKS|FAS|FOB|CNF|CIF)$/
#	}.each do |field, regex|
#	  validates field, :format => { :with => regex }
#	end # presence validation
	validates :name, :presence => true
	@@name_filter = /(\s|\W|_)/
	
	# Callbacks
	before_validation :p_process_name
		
	# Duck-typing yay!
	def has( item = nil )
		if item.nil?
			self.items
		else
			item.location_id = self.id
			self.items if item.save
		end
	end # has
	
	def self.search_names( name )
		Location.find_by_name( name.strip.downcase.squeeze(" ").gsub( @@name_filter, "" ) )
	end # search_names
	
	def make_official
		self.official = true
		self.save
	end # make_official
	
	private
		def p_process_name
			if self.name.nil? || Location.exists?( :name => self.name )
				self.name = "generic" + ( Location.count + 1 ).to_s
			else
				self.name = self.name.strip.downcase.squeeze(" ").gsub( @@name_filter, "" ) unless self.name.nil?
			end # generic name
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
