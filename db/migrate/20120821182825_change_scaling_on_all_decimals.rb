class ChangeScalingOnAllDecimals < ActiveRecord::Migration
  def up
  	change_column :items, :maw, :decimal, :scale => 4, :precision => 10
  	[:services, :ships, :trucks].each do |col|
	  	change_column col, :price, :decimal, :scale => 2, :precision => 10
	  end # each col
	  [:offer, :maw].each do |col|
		  change_column :bids, col, :decimal, :scale => 4, :precision => 10
		end # each col
  end # up

  def down
  	change_column :items, :maw, :decimal
  	[:services, :ships, :trucks].each do |col|
	  	change_column col, :price, :decimal
	  end # each col
	  [:offer, :maw].each do |col|
		  change_column :bids, col, :decimal
		end # each col
  end # down
end
