class AddMetadataToElements < ActiveRecord::Migration
  def change
    add_column :elements, :metadata, :string
  end
end
