class PagesController < ApplicationController
  def home
  	@items = Item.limit(25)
  end # home

end # PagesController
