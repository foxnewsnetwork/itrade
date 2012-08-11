class AddOfficialToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :official, :boolean, :null => false, :default => false
  end # change
end # AddOficialToLocations
