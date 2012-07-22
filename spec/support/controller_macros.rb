require 'factories'
module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in Factory(:admin) # Using factory girl as an example
    end # before each
  end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @current_user = Factory(:user)
      # user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the confirmable module
      sign_in @current_user
    end # before
  end # login_user
  
  def create_product(symbol = :login)
		before(:each) do
			@current_user = Factory(:user)
			if symbol == :login
				@request.env["devise.mapping"] = Devise.mappings[:user]
			  # user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the confirmable module
			  sign_in @current_user
			end # something else
			@myuser = @current_user
			raise "fuck this earth error" if @myuser.nil?
			@another_user = User.create Factory.next(:user)
			@item = Factory(:item, :user => @myuser)
			@another_item = Factory(:item, :user => @another_user)
			@bid = Factory(:bid, :user => @myuser, :item => @another_item)
			@another_bid = Factory(:bid, :user => @another_user, :item => @item)
			@location_data = Factory.next(:location)
		end # before each
	end # create_product
end # module
