class AuxiliariesController < ApplicationController
	before_filter :filter_regular_users, :only => [:create, :destroy]
	# Note: the auxiliary controller doesn't create auxiliaries
	def create
		{ :ship => Ship, :truck => Truck, :service => Service }.each do |key, model|
			next if params[key].nil?
			duck = params[key]
			raise "No Ducks Error" if duck.nil?
				[:start, :finish].each do |marker|
					place = duck[marker]
					place ||= { 
						:id => duck[ (marker.to_s + "_id").to_sym ], 
						:type => duck[ (marker.to_s + "_type").to_sym ] 
					} # place
					raise "Massive Assfucker Error" if place.nil?
					(@locations ||= { })[marker] = Target.get_from_id_type( place[:id], place[:type] )
					@locations[marker] ||= Yard.create_on_duplicate( place )
					raise "#{marker} location error" if @locations[marker].nil?
				end unless key == :service # each marker
			raise "Why no ducks? Error" if duck.nil?
			unless duck.nil?
				goose = {}
				model.attr_accessible[:default].each do |attribute|
					next if attribute.blank? || attribute == "start" || attribute == "finish" || duck[attribute.to_sym].nil?
					goose[attribute.to_sym] = duck[attribute.to_sym]
				end # each attribute
				(@ducks ||= {})[key] = model.create goose
				raise "Fucking Hell Ducks Error" if @ducks[key].nil?
				@ducks[key].from(@locations[:start]).to(@locations[:finish]) unless key == :service
			end # no duck
		end # each key model
		respond_to do |format|
			format.html { render :nothing => true }
			format.js
		end # respond_to
	end # create
	
	def destroy
	
	end # destroy
	
	def index
		@title = "Aux Response"
		{ :ship => Ship, :truck => Truck, :service => Service }.each do |key, model|
			next unless params[:q] == key.to_s || params[:q] == key.to_s.pluralize
			@ducks = model.order( "created_at DESC" )
			@ducks.each do |duck|
				next if duck.is_a? Service
				raise "#{duck.to_s} doesn't have a home" if duck.origination.nil?
				raise "#{duck.to_s} doesn't have a goal" if duck.destination.nil?
			end # each duck
			respond_to { |f| f.json { render "#{key.to_s}", :handler => ["json_builder"] } }
			break
		end # each key model
		return
	end # index
	
end # AuxiliariesController
