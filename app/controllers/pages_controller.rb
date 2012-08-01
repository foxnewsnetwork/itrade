class PagesController < ApplicationController
  def home
  	@title = "Home"
  	@items = Item.limit(25)
  end # home

end # PagesController
