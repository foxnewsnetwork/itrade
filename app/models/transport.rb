module Transport
	def self.transportable( duck )
		duck.attr_accessible :company, :finish, :price, :start
  
		# Relationshiops
		duck.belongs_to :origination, :class_name => "Location", :foreign_key => :start
		duck.belongs_to :destination, :class_name => "Location", :foreign_key => :finish
	end # transportable
	
	def from(id)
		self.start = id
		return self unless self.start.nil?
		nil
	end # from
	
	def to(id)
		self.finish = id
		return self unless self.finish.nil?
		nil
	end # to
end # Transport
