class ShipsController < ApplicationController
	before_filter :filter_regular_users, :only => [:create, :destroy]
	
	def create
		params[:ships].each do |ship|
			raise "Ship says FUCK YOU error" if ship[:origination].nil? || ship[:destination].nil?
			@start ||= Port.find_by_id( ship[:origination][:id] ) unless ship[:origination][:id].nil?
			@start ||= Port.find_by_code( ship[:origination][:code] ) unless ship[:origination][:code].nil?
			@finish ||= Port.find_by_id( ship[:destination][:id] ) unless ship[:destination][:id].nil?
			@finish ||= Port.find_by_code( ship[:destination][:code] ) unless ship[:destination][:code].nil?
			raise "No origination port error #{ship[:origination][:code]}" if @start.nil? 
			raise "No destination port error #{ship[:destination][:code]}" if @finish.nil?
			shit = {}
			Ship.attr_accessible[:default].map { |x| x.to_sym }.each do |key|
				next if key == :""
				shit[key] = ship[key]
			end # each key val
			Ship.new(shit).from(@start).to(@finish).save!
			# FIXME: get activerecord-import up in here
		end # each ship
		respond_to do |format|
			format.html { render :nothing => true }
			format.js
		end # respond_to
	end # create
	
	def destroy
		@ship = Ship.find_by_id params[:id]
		@ship.destroy unless @ship.nil?
		respond_to do |f|
			f.html { render :nothing => true }
			f.js
		end # respond_to
	end # destroy
	
	def index
		@ports = {}
		[:start, :finish].each do |l|
			@ports[l] = Port.find_by_id( params[l] )
			@ports[l] ||= Port.find_by_code( params[l] )
		end # each loc
		@ships = Ship.to_and_from(@ports[:finish], @ports[:start]) unless @ports[:finish].nil? || @ports[:start].nil?
		@ships ||= Ship.to( @ports[:finish] ) unless @ports[:finish].nil?
		@ships ||= Ship.from( @ports[:start] ) unless @ports[:start].nil?
		raise "Fucking Hell #{@ports.to_s} ERROR" if @ships.nil? || @ships.empty?
		respond_to do |f|
			f.json { render "ship", :handler => ["json_builder"] }
		end # respond_to f
	end # index
end # ShipsController 
