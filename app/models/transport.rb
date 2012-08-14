module Transport
	def self.transportable( duck )
		duck.attr_accessible :company, :price, :start, :finish
  
		# Relationshiops
		duck.belongs_to :origination, :class_name => "Target", :foreign_key => :start
		duck.belongs_to :destination, :class_name => "Target", :foreign_key => :finish
	end # transportable
	
	def from(duck)
		self.start = Target.new.establish(duck).id
		self.save!
		return self unless self.start.nil?
		nil
	end # from
	
	def to(duck)
		self.finish = Target.new.establish(duck).id
		self.save!
		return self unless self.finish.nil?
		nil
	end # to
end # Transport
