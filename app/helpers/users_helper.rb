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
	  	flash[:notice] = t(:require_login, :scope => [:helpers, :users])
	  	redirect_to new_user_session_path
	  end # user_signed_in?
  end # filter_anonymouse_users
  
  def filter_wrong_users
  	if is_wrong?( current_user )
  		flash[:notice] = t(:require_correct, :scope => [:helpers, :users])
  		redirect_to root_path
  	end # if wrong
  end # filter_wrong_users
  
  def filter_regular_users
  	unless user_signed_in? && current_user.admin
  		flash[:error] = t(:require_admin, :scope => [:helpers, :users])
  		redirect_to root_path
  	end # unless 
  end # filter_regular_users
end # UserHelpers
