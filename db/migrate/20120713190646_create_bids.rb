class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.integer :item_id, :null => false
      t.decimal :offer, :default => 0.0
      t.string :units, :default => "USD"

      t.timestamps
    end # create
  end # change
end # CreateBids
