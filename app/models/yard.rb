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
  
  def self.create_on_duplicate( data = {} )
  	search_params = {}
  	Yard.attr_accessible[:default].each do |attribute|
  		next if attribute.blank?
  		search_params[attribute.to_sym] = data[attribute.to_sym]
  	end # attribute
  	result = Yard.where(search_params).limit(1)
  	raise "Yard getting filled by pointless duplicate entries ERROR" if result.count > 1
  	Yard.create data if result.empty?
  	result.first unless result.empty?
  end # create_on_duplicate
end # Yard
