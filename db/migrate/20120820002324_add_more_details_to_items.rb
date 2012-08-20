class AddMoreDetailsToItems < ActiveRecord::Migration
  def change
    add_column :items, :color, :string
    add_column :items, :contamination, :string
  end
end
