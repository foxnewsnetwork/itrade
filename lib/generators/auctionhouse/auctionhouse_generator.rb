require 'rails/generators/active_record'

class AuctionhouseGenerator < Rails::Generators::NamedBase
	# Modules mixins
  include Rails::Generators::Migration
  include Rails::Generators::ResourceHelpers
  
  # Setup and description
  source_root File.expand_path('../templates', __FILE__)
  desc "Generates the model, controller, and migration given the NAME as well as " <<
  	"setups the routing to have a simplistic auction system."
  
  def create_controllers
  	template "controllers/items_controller.rb", "app/controllers/#{file_name.pluralize}_controller.rb"
  	template "controllers/bids_controller.rb", "app/controllers/#{file_name}_bids_controller.rb"
  end # create_controller
  
  def create_models
  	template "models/item.rb", "app/models/#{file_name}.rb"
  	template "models/bid.rb", "app/models/#{file_name}_bid.rb"
  end # create_models
    
  def create_migration
		migration_template "migrations/migration.rb", "db/migrate/auctionhouse_create_#{table_name}"
  end # create_migration
  
  def add_auctionhouse_routes
  	auctionhouse_routes = %Q(resources :#{plural_name} do
  		resources :#{singular_name}_bids, :only => [:create, :destroy, :update]
  	end # #{plural_name})
  	route auctionhouse_routes
  end # add_auctionhouse_routes
  
  def self.next_migration_number(data)
  	ActiveRecord::Generators::Base.next_migration_number(data)
  end # next_migration_number
end # AuctionhouseGenerator
