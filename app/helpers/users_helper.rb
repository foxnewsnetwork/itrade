module UsersHelper
	def filter_anonymous_users
  	unless user_signed_in?
	  	flash[:notice] = t(:require_login)
	  	redirect_to new_user_session_path
	  end # user_signed_in?
  end # filter_anonymouse_users
end # UserHelpers
