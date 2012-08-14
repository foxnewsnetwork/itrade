class AddTargetIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :target_id, :integer
    add_index :items, :target_id
  end # change
end
