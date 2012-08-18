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
				self.where( :start => pre_search_stuff(origin).map { |x| x.id }, :finish => pre_search_stuff(destiny).map { |x| x.id } ).order( "price ASC" )
			end # to_and_from
			
			def from(place)
				self.where( :start => pre_search_stuff(place).map { |x| x.id } ).order( "price ASC" )
			end # from
			def to(place)
				self.where( :finish => pre_search_stuff(place).map { |x| x.id } ).order( "price ASC" )
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
			
			def find_by_best_routes( data, limit=10 )
				origin = data[:origin]
				destiny = data[:destiny]
				raise "FUCK YOU SQL INJECT! #{limit}" unless limit.is_a?( Fixnum )
				raise "INCORRECT USAGE ERROR! #{origin.class.to_s}" unless origin.is_a?(Yard)
				raise "INCORRECT USAGE ERROR! #{destiny.class.to_s}" unless destiny.is_a?(Port)
				if destiny.domestic == false
					sql_statement = %Q(
						SELECT s.id AS ship_id, s.price AS ship_price, s.finish AS finish,
						t.id AS truck_id, t.price AS truck_price, t.start AS start, t.finish AS exchange
						FROM ports AS p1
						INNER JOIN targets AS t1 ON t1.t_id = p1.id AND t1.t_type = 'port'
						INNER JOIN ships AS s ON s.finish = t1.id
						INNER JOIN targets AS t2 ON t2.id = s.start AND t2.t_type = 'port'
						INNER JOIN ports AS p2 ON p2.id = t2.t_id 
						INNER JOIN targets AS t3 ON t3.t_id = p2.id AND t3.t_type = 'port'
						INNER JOIN trucks AS t ON t.finish = t3.id
						INNER JOIN targets AS t4 ON t4.id = t.start AND t4.t_type = 'yard'
						INNER JOIN yards AS y ON y.id = t4.t_id
						WHERE p1.id = '#{destiny.id}' AND y.id = '#{origin.id}'
						ORDER BY (s.price + t.price) ASC
						LIMIT #{limit}
					)
					@results = self.connection.select_all( sql_statement )
				else
					raise "USE THIS ONLY FOR FOREIGN PORTS ERROR. #{destiny.domestic}"
				end # unless domestic port
				return @results
			end # find_by_best_routes
			
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
