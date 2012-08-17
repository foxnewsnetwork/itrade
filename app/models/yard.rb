# == Schema Information
#
# Table name: yards
#
#  city           :string(255)
#  created_at     :datetime         not null
#  id             :integer          not null, primary key
#  state          :string(255)
#  street_address :string(255)
#  updated_at     :datetime         not null
#  zip            :string(255)
#

class Yard < ActiveRecord::Base
  attr_accessible :city, :state, :street_address, :zip
  
  before_validation do
  	self.zip = self.zip.downcase.strip[0..4]
  	self.city = self.city.strip.squeeze(" ")
  	self.state = self.state.upcase
  end # before_validation
  
  { :zip => /^\d{5}$/ , :state => /^[A-Z]{2}$/ }.each do |field, regex|
	  validate field, :format => { :with => regex }
	end # each field regex
  
  def self.create_on_duplicate( data )
  	search_params = {}
  	raise "NO DATA ERROR" if data.nil? || data.empty?
  	Yard.attr_accessible[:default].each do |attribute|
  		next if attribute.blank? || data[attribute.to_sym].nil?
  		search_params[attribute.to_sym] = data[attribute.to_sym]
  	end # attribute
  	result = Yard.where(search_params).limit(5)
  	raise "Yard getting filled by pointless duplicate entries ERROR" if result.count > 1
  	return Yard.create search_params if result.empty?
  	return result.first
  end # create_on_duplicate
  
  def self.find_by_all_fields( data )
  	search_params = {}
  	raise "NO DATA ERROR" if data.nil? || data.empty?
  	Yard.attr_accessible[:default].each do |attribute|
  		next if attribute.blank?
  		search_params[attribute.to_sym] = data[attribute.to_sym]
  	end # attribute
  	result = Yard.where(search_params).limit(2)
  	raise "Yard getting filled by pointless duplicate entries ERROR" if result.count > 1
  	return result.first
  end # fina_by_all_fields
end # Yard
