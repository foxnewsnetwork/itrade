module Transport
	def self.transportable( duck )
		duck.attr_accessible :company, :finish, :price, :start
  
		# Relationshiops
		duck.belongs_to :origination, :class_name => "Location", :foreign_key => :start
		duck.belongs_to :destination, :class_name => "Location", :foreign_key => :finish
	end # transportable
end # Transport
