# == Schema Information
#
# Table name: targets
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  t_id       :integer
#  t_type     :string(255)
#  updated_at :datetime         not null
#

class Target < ActiveRecord::Base
  # attributes
  attr_accessible :t_id, :t_type
  
  # relationships
  has_many :bids
  
  # class statics
  @@typesets = { 'yard' => Yard, 'port' => Port }
  
	def self.get_from_id_type(id,type)
		return nil if @@typesets[type.to_s.downcase].nil?
		@@typesets[type.to_s.downcase].find_by_id(id)
	end # get_from_id_type
	  
  def retrieve
  	@@typesets[self.t_type].find_by_id( self.t_id )
  end # retrieve
  
  def at
  	retrieve
  end # at
  
  def establish( duck )
  	self.t_type = duck.class.to_s.downcase
  	raise "#{self.t_type} IS A FUCKING GOOSE, NOT A DUCK IN TARGET.ESTABLISH ERROR" if @@typesets[self.t_type].nil?
  	self.t_id = duck.id
  	return self if self.save
  	nil
  end # establish
end # Target
