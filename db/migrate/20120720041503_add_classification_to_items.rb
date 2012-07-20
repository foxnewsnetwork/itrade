class AddClassificationToItems < ActiveRecord::Migration
  def change
    add_column :items, :type, :string
    add_column :items, :category, :string, :null => false, :default => 'plastic'
    add_column :items, :location_id, :integer
  end
end
