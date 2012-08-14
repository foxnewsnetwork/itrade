class PagesController < ApplicationController
  before_filter :filter_regular_users, :only => :admin
  def home
  	@title = "Home"
  	@items = Item.limit(25)
  end # home

	def admin
		@title = "Administration"
		@users = User.paginate(:page => params[:user_page], :per_page => 5)
		@roots = Category.roots
		@ships = Ship.paginate(:page => params[:ship_page], :per_page => 5)
		@trucks = Truck.paginate(:page => params[:truck_page], :per_page => 5)
		@services = Service.paginate(:page => params[:service_page], :per_page => 5)
		[Yard, Port].each do |model|
			(@locations ||= {})[model.to_s.downcase.to_sym] = model.paginate(:page => params[(model.to_s.downcase + "_page" ).to_sym], :per_page => 5)
		end # each model
	end # admin
end # PagesController
