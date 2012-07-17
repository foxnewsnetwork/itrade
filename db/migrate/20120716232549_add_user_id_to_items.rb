class AddUserIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :user_id, :integer
    add_index :items, :user_id
    add_index :items, [:user_id, :id], :unique => true
  end # Change
end
