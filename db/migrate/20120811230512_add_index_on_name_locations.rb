class AddIndexOnNameLocations < ActiveRecord::Migration
  def up
  	add_index :locations, :name, :unique => true
  end # up

  def down
  	remove_index :locations, :name
  end # down
end
