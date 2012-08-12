class AuxiliariesController < ApplicationController
	before_filter :filter_regular_users, :only => [:create, :destroy]
	# Note: the auxiliary controller doesn't create auxiliaries
	def create
		{ :ship => Ship, :truck => Truck, :service => Service }.each do |key, model|
			next if params[key].nil?
			duck = params[key]
			raise "No Ducks Error" if duck.nil?
				[:start, :finish].each do |marker|
					location = duck[marker]
					raise "Massive Assfucker Error" if location.nil?
					(@locations ||= { })[marker] = Location.find_by_id( location[:id] )
					@locations[marker] ||= Location.create( location )
					raise "#{marker} location error" if @locations[marker].nil?
				end unless key == :service # each marker
			raise "Why no ducks? Error" if duck.nil?
			unless duck.nil?
				(@ducks ||= {})[key] = model.create duck
				raise "Fucking Hell Ducks Error" if @ducks[key].nil?
				@ducks[key].from(@locations[:start].id).to(@locations[:finish].id) unless key == :service
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
			respond_to { |f| f.json { render "#{key.to_s}", :handler => ["json_builder"] } }
			break
		end # each key model
		return
	end # index
	
end # AuxiliariesController
