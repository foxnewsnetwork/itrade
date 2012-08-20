class RegistrationsController < Devise::RegistrationsController
	before_filter :filter_anonymous_users, :only => [:update, :edit]
	def new
		@back_path = request.env['HTTP_REFERER']
		resource = build_resource({})
    respond_with resource
	end # new
	
	def create
  	build_resource
		
    if resource.save
      if resource.active_for_authentication?
        set_flash_message :success, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        # respond_with resource, :location => after_sign_up_path_for(resource)
        back_path = params[:back_path] unless params[:back_path].nil? || params[:back_path].blank?
				back_path ||= after_sign_up_path_for(resource)
        respond_with resource, :location => back_path
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end # resource active
    else
      clean_up_passwords resource
      respond_with resource
    end # resource.save
    
  end # create
end # RegistrationsController
