class AddParentIdToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :parent_id, :integer
    add_index :categories, :parent_id
  end
end
