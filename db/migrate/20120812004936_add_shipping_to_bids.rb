class AddShippingToBids < ActiveRecord::Migration
  def change
    add_column :bids, :shipping, :string
  end
end
