class ApplicationController < ActionController::Base
  protect_from_forgery
  include UsersHelper
  include PagesHelper
  include CategoriesHelper
  def after_sign_in_path_for(resource)
    # user_path resource # <- Path you want to redirect the user to.
    :back
  end # after_sign_in_path_for
end # ApplicationController
