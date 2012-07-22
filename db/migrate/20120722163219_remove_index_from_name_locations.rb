class RemoveIndexFromNameLocations < ActiveRecord::Migration
  def up
  	remove_index :locations, :name
  end

  def down
  	add_index :locations, :name, :unique => true
  end
end
