class TrucksController < ApplicationController
	before_filter :filter_regular_users, :only => [:create, :destroy]
	
	def create
		params[:trucks].each do |truck|
			raise "Truck says FUCK YOU error" if truck[:origination].nil? || truck[:destination].nil?
			@places = {}
			{:d_type => truck[:destination], :o_type => truck[:origination] }.each do |key, data|
				if truck[key] == "yard"
					@places[key] = Yard.create_on_duplicate data
					raise "Yard #{data.to_s} #{key} ERROR" if @places[key].nil?
				elsif truck[key] == "port"
					@places[key] = Port.find_by_code( data[:code] ) unless data[:code].nil?
					@places[key] ||= Port.find_by_id( data[:id] ) unless data[:id].nil?
					raise "Port #{data.to_s} #{key} ERROR" if @places[key].nil?
				else
					raise "WTF IS THIS #{data.to_s} #{key} ERROR"
				end # if is yard
			end # each key data
			@places.each do |key, place|
				raise "bad #{key} ERROR" unless place.is_a?( Yard ) || place.is_a?( Port )
			end # null check
			shit = {}
			Truck.attr_accessible[:default].map { |x| x.to_sym }.each do |key|
				next if key == :"" || key == :start || key == :finish ||truck[key].nil?
				shit[key] = truck[key]
			end # each key val
			truck = Truck.new(shit)
			[:d_type, :o_type].each do |field|
				raise "Bad #{field} ERROR" if @places[field].nil?
			end # null check 2
			truck.to_and_from( @places[:d_type], @places[:o_type] )
			raise "WTF Invalid Error" unless truck.valid?
			raise "No origination error" if truck.origination.at.nil?
			raise "No destination error" if truck.destination.at.nil?
			(@trucks ||= []) << truck if truck.valid?
			# FIXME: get activerecord-import up in here
		end # each ship
		respond_to do |format|
			format.html { render :nothing => true }
			format.js
		end # respond_to
	end # create
	
	def destroy
		@truck = Truck.find_by_id params[:id]
		@truck.destroy unless @truck.nil?
		respond_to do |f|
			f.html { render :nothing => true }
			f.js
		end # respond_to
	end # destroy
	
	# There is some weird ass rails bug here which prevents loading destination.at
	# no matter what is happening when in the json file. I don't know what is causing
	# this and I can't be figure it out... so I will just work around it
	def index
		[:s, :f].each do |k|
			unless params[k].nil?
				n = params[k]
				(@p ||= {})[k] = Target.get_from_id_type( n[:id], n[:type] ) unless n[:id].nil? || n[:type].nil?
				@p[k] ||= Yard.where( :city => n[:city] ) if n[:type] == "yard"
			end # unless no k
		end # each k
		unless @p.nil?
			@trucks = Truck.to_and_from( @p[:f], @p[:s] ) unless @p[:f].nil? || @p[:s].nil?
			@trucks ||= Truck.from(@p[:s]) unless @p[:s].nil?
			@trucks ||= Truck.to(@p[:f]) unless @p[:f].nil?
			# raise "NO TRUCK ERROR" if @trucks.empty?
			@trucks.each do |truck|
				raise "why nil? #{truck.to_json}" if truck.destination.at.nil?	
			end # each nil check
		else
			@trucks ||= Truck.limit(50)
		end # unless p nil
		respond_to do |f|
			f.json { render "truck", :handler => ["json_builder"] }
			f.js
		end # respond_to f
	end # index
end # TruckController
