require File.join( File.dirname(__FILE__), "integration_macros.rb")

RSpec.configure do |config|
  # Following instructions to let devise work within rspec
  config.include Devise::TestHelpers, :type => :controller
  config.extend ControllerMacros, :type => :controller  
  
  config.include IntegrationMacros
  config.extend IntegrationMacros
end # configure
