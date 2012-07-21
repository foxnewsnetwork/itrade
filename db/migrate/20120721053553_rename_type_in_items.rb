class RenameTypeInItems < ActiveRecord::Migration
  def change
  	rename_column :items, :type, :material
  end # change
end # Rename
