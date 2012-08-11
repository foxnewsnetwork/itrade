class AddMawToBids < ActiveRecord::Migration
  def change
    add_column :bids, :maw, :decimal
  end
end
