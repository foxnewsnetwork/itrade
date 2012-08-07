class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :name, :null => false, :default => "incomplete"
      t.string :effect
      t.integer :item_id, :null => false

      t.timestamps
    end # create table
    add_index :statuses, :item_id
  end # change
end # CreateStatuses
