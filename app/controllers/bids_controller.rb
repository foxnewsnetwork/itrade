class BidsController < ApplicationController
	before_filter :filter_anonymous_users, :only => [:new, :create, :destroy]
	def show
		@bid = Bid.find_by_id params[:id]
		if @bid.nil?
			render "public/404" 
			return
		end # no bid
		@item = @bid.item
		@location = @bid.location
		@location ||= Location.new
		@bids = @item.bids
	end # show
	
	def new
		@title = "New Bid"
		@item = Item.find_by_id params[:item_id]
		if @item.nil?
			render "public/404" 
			return
		end # if nil
		@asking_price = @item.bids.find_by_user_id( @item.user_id )
		@bids = @item.bids
		@bid = current_user.bids.new
		@tabs = [:price, :transportation, :insurance]
		@ports = Port.all
		@yards = Yard.all
		@ship = Ship.first
		@truck = Truck.first
		@service = Service.first
		
	end # new
	
	def edit
	
	end # edit

	def create
		@bid = current_user.bid params[:bid], params[:item_id]
		if (params[:location].nil? || params[:location][:name].nil?) && params[:yard].nil? && params[:port].nil?
			raise "Wow, Fuck You Error"
			flash[:error] = t(:failed, :scope => [:controllers, :bids, :create, :location])
		else
			unless params[:port].nil? || params[:port][:id].nil?
				@location = Port.find_by_id params[:port][:id]
				@location ||= Port.find_by_code params[:port][:code]
			end # unless
			unless params[:yard].nil?
				@location ||= Yard.create_on_duplicate params[:yard]
			end # unless
			@location ||= Location.search_names params[:location][:name]
			@location ||= Location.create params[:location]
			raise "Null Location Error" if @location.nil?
			unless @location.nil?
				@bid.at @location 
				unless params[:auxiliaries].nil?
					params[:auxiliaries].each do |aux|
						case aux[:type]
							when "ship"
								@duck = Ship.find_by_id aux[:id] 
							when "truck"
								@duck = Truck.find_by_id aux[:id]
							when "service"
								@duck = Service.find_by_id aux[:id]
							else
								flash[:error] = t(:failed, :scope => [:controllers, :bids, :create, :auxiliary])
						end # case aux
						raise "No duck error" if @duck.nil?
						((@auxiliaries ||= []) << @bid.has( @duck ) ) unless @duck.nil?
					end # each aux
				end # unless no aux
				{ :service => Service, :truck => Truck, :ship => Ship }.each do |key, model|
					next if params[key].nil?
					@duck = model.find_by_id params[key][:id]
					flash[:error] = t(:failed, :scope => [:controllers, :bids, :create, :auxiliary]) if @duck.nil?
					raise "#{key} duck error" if @duck.nil?
					( (@auxiliaries ||= []) << @bid.has( @duck ) )unless @duck.nil?
				end # each key model
				flash[:success] = t(:success, :scope => [:controllers, :bids, :create])
			else
				flash[:error] = t(:failed, :scope => [:controllers, :bids, :create, :location])
			end # unless location
		end # if bad location
		redirect_to item_path params[:item_id]
	end # create
	
	def destroy
		@item = Item.find_by_id params[ :item_id ]
		@bid = Bid.find_by_id params[ :id ]
		if current_user == @bid.user
			@bid.destroy
			flash[:success] = t( :success_bid_destroy )
		else
			flash[:error] = t( :fail_bid_destroy )
		end # if correct user
		redirect_to item_path @item
	end # destroy
	
	def update
		@bid = Bid.find_by_id params[:id]
		if @bid.nil?
			render "public/404"
		end # if no bid
		@item = Item.find_by_id params[:item_id]
		if current_user == @bid.user
			unless params[:location].nil?
				if @bid.location.nil?
					@bid.at Location.create( params[:location] )
				else
					@bid.location.update_attributes params[:location]
				end # if no location
				flash[:error] = t(:fail_location_create, :scope => [:controller, :bids, :update] ) if @bid.location.nil?
			end # unless no location params
			unless params[:bid].nil?
				if @bid.update_attributes params[:bid]
					flash[:success] = t(:success_bid_update)
				else
					flash[:error] = t(:fail_bid_update)
				end # if success update
			end # unless no bid params
		else
			flash[:error] = t(:fail_bid_update)
		end # if correct user
		redirect_to [@item, @bid]
	end # update
end # BidsController
