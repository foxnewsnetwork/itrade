class AddShippingToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :shipping, :string, :null => false, :default => "EXWORKS"
  end
end
