class ChangePaydateToTargetIdBids < ActiveRecord::Migration
  def up
  	remove_column :bids, :paydate
  	add_column :bids, :target_id, :integer
  end # up

  def down
  	add_column :bids, :paydate, :timestamp
  	remove_column :bids, :target_id
  end # down
end # class
