RSpec.configure do |config|
  # Following instructions to let devise work within rspec
  config.include Devise::TestHelpers, :type => :controller
  config.extend ControllerMacros, :type => :controller  
end
