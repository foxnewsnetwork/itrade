class PagesController < ApplicationController
  before_filter :filter_regular_users, :only => :admin
  def home
  	@title = "Home"
  	@items = Item.limit(25)
  end # home

	def admin
		@title = "Administration"
		@users = User.all
		@roots = Category.roots
	end # admin
end # PagesController
