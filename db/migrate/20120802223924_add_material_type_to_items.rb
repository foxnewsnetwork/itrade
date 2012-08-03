class AddMaterialTypeToItems < ActiveRecord::Migration
  def change
    add_column :items, :material_type, :string
  end # change
end # AddMaterialTypeToItems
