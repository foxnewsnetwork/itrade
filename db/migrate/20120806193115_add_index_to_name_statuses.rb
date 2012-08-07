class AddIndexToNameStatuses < ActiveRecord::Migration
  def change
  	add_index :statuses, [:item_id, :name], :unique => true
  	add_index :statuses, :name
  end # change
end # AddIndexToNameStatus
