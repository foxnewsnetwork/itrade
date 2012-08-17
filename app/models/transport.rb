module Transport
	def self.transportable( duck )
		duck.attr_accessible :company, :price, :start, :finish
  
		# Relationshiops
		duck.belongs_to :origination, :class_name => "Target", :foreign_key => :start, :dependent => :destroy
		duck.belongs_to :destination, :class_name => "Target", :foreign_key => :finish, :dependent => :destroy
		
		class << duck
			@@ragequit = lambda do |p|
				case p.class.to_s.downcase.to_sym
					when :yard, :port
						return { p.class.to_s.downcase.to_sym => [p.id] }
					when :array, :"activerecord::relation"
						r = { :yard => [], :port => [] }
						p.each do |q|
							@@ragequit.call(q).each do |key, val|
								r[key] += val
							end # each key val
						end # each q
						return r	
					else
						raise "#{p.class.to_s} IS A GOOSE, NOT DUCK ERROR" 
				end # case p class
			end # ragequit
			
			def to_and_from( destiny, origin )
				self.where( :start => pre_search_stuff(origin).map { |x| x.id }, :finish => pre_search_stuff(destiny).map { |x| x.id } )
			end # to_and_from
			
			def from(place)
				self.where( :start => pre_search_stuff(place).map { |x| x.id } )
			end # from
			def to(place)
				self.where( :finish => pre_search_stuff(place).map { |x| x.id } )
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
			
			private
				def pre_search_stuff(place)
					results = []
					@@ragequit.call(place).each do |where, ids|
						results += Target.where( :t_id => ids, :t_type => where.to_s )
					end # each where ids
					return results
				end # pre_search_stuff
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
