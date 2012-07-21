class RefactorLocationsInUsers < ActiveRecord::Migration
  def up
  	add_column :users, :location_id, :integer
  	remove_column :users, :address
  	remove_column :users, :city
  	remove_column :users, :state
  	remove_column :users, :zip
  	remove_column :users, :country
  end

  def down
  	remove_column :users, :location_id
  	add_column :users, :address, :string, :null => false, :default => ""
  	add_column :users, :city, :string, :null => false, :default => ""
  	add_column :users, :state, :string, :null => false, :default => ""
  	add_column :users, :zip, :string, :null => false, :default => ""
  	add_column :users, :country, :string, :null => false, :default => ""
  end
end # Refactor
