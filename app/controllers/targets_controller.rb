class TargetsController < ApplicationController

  def index
  	@yard = Yard.find_by_id( params[:yard_id] )
  	@port = Port.find_by_id( params[:port_id] )
  	if @yard.nil? || @port.nil?
  		render :nothing => true
  		return
  	end # if bad data
  	
  	if @port.domestic
  		raise "INCORRECT USAGE ERROR - domestic port #{@port}"
  	else
  		@combos = Ship.find_by_best_routes( :origin => @yard, :destiny => @port )
  	end # if port domestic
  	
  	respond_to { |f| f.js }
  	
  end	 # index
  
end # TargetsController
