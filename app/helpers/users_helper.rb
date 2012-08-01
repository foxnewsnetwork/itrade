module UsersHelper
	def is_anonymous?
		user_signed_in?
	end # anonymous_user

	def is_correct?(user)
		is_anonymous? && current_user == user
	end # correct_user
	
	def is_wrong?(user)
		!is_correct?(user)
	end # is_wrong
	
	def filter_anonymous_users
  	unless user_signed_in?
	  	flash[:notice] = t(:require_login)
	  	redirect_to new_user_session_path
	  end # user_signed_in?
  end # filter_anonymouse_users
end # UserHelpers
