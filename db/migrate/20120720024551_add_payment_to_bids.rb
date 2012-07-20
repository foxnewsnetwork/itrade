class AddPaymentToBids < ActiveRecord::Migration
  def change
    add_column :bids, :paytype, :string
    add_column :bids, :paydate, :timestamp
    add_column :bids, :location_id, :integer
  end
end
