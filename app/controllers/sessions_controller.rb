class SessionsController < Devise::SessionsController
	def create
		if request.env["HTTP_REFERER"].nil?
			super.create
		else
			resource = warden.authenticate!(auth_options)
			set_flash_message(:success, :signed_in) if is_navigational_format?
			sign_in(resource_name, resource)
			respond_to do |format|
				format.html { redirect_to :back }
				format.js
			end # respond_to
		end # if no referer
	end # create
end # SessionsController
