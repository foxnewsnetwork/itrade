module Transport
	def self.transportable( duck )
		duck.attr_accessible :company, :price, :start, :finish
  
		# Relationshiops
		duck.belongs_to :origination, :class_name => "Target", :foreign_key => :start, :dependent => :destroy
		duck.belongs_to :destination, :class_name => "Target", :foreign_key => :finish, :dependent => :destroy
		
		class << duck
			def to_and_from( destiny, origin )
				unless origin.is_a?( Yard ) || origin.is_a?( Port ) || destiny.is_a?( Yard ) || destiny.is_a?( Port )
					raise "to and from #{place.class.to_s} IS A GOOSE, NOT A DUCK ERROR #{__FILE__}!!" 
				end # unless hopeless origin or bleak destiny
				froms = Target.where( :t_id => origin.id, :t_type => origin.class.to_s.downcase )
				raise "HELL #{froms.to_a}" if froms.empty?
				tos = Target.where( :t_id => destiny.id, :t_type => destiny.class.to_s.downcase )
				raise "HECK #{tos.to_a}" if tos.empty?
				result = self.where( :start => (froms.map { |x| x.id }), :finish => (tos.map { |x| x.id }) )
				result.each do |r|
					raise "#{r.to_json} ERROR" if r.destination.at.nil?
				end # each r
				return result
			end # to_and_from
			def from(place)
				raise "from #{place.class.to_s} IS A GOOSE, NOT A DUCK ERROR #{__FILE__}!!" unless place.is_a?( Yard ) || place.is_a?( Port )
				@targets = Target.where( :t_id => place.id, :t_type => place.class.to_s.downcase )
				self.where( :start => @targets.map { |x| x.id } )
			end # from
			def to(place)
				raise "to #{place.class.to_s} IS A GOOSE, NOT A DUCK ERROR #{__FILE__}!!" unless place.is_a?( Yard ) || place.is_a?( Port )
				@targets = Target.where( :t_id => place.id, :t_type => place.class.to_s.downcase )
				self.where( :finish => @targets.map { |x| x.id } )
			end # to
			
			def by_price
				self.order( "price ASC" )
			end # price
			
			def by_origin(duck)
				ducks = Target.where( :t_id => duck.id, :t_type => duck.class.to_s.downcase ).map { |x| x.id }
				return [] if ducks.nil? || ducks.empty?
				self.where( :start => ducks )
			end # origin
			
			def by_destination(duck)
				ducks = Target.where( :t_id => duck.id, :t_type => duck.class.to_s.downcase ).map { |x| x.id }
				return [] if ducks.nil? || ducks.empty?
				self.where( :finish => ducks )
			end # destination
			
			
		end # << duck
	end # transportable
	
	def to_and_from(destiny, origin)
		self.start = Target.new.establish(origin).id
		self.finish = Target.new.establish(destiny).id
		self.save!
		raise "From Error" if self.origination.nil?
		raise "To Error" if self.destination.nil?
		return self
	end # to_and_from
	
	def from(duck)
		raise "#{duck.class.to_s} ERROR" unless duck.is_a?(Yard) || duck.is_a?(Port)
		self.start = Target.new.establish(duck).id
		self.save!
		return self unless self.start.nil?
		nil
	end # from
	
	def to(duck)
		raise "#{duck.class.to_s} ERROR" unless duck.is_a?(Yard) || duck.is_a?(Port)
		self.finish = Target.new.establish(duck).id
		self.save!
		return self unless self.finish.nil?
		nil
	end # to
end # Transport
