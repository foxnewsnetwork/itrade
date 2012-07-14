class AuctionHouseCreate<%= table_name.camelize %> < ActiveRecord::Migration
	def change
    create_table(:<%= table_name %>) do |t|
			t.string :title, :null => false, :default => "Untitled"
			t.description :text
			t.decimal :quantity, :null => false, :default => 1.0
			t.string :units, :null => false, :default => "unit"
			t.timestamps
		end # create_table
		create_table( :<%= table_name.singularize %>_bids ) do |t|
			t.integer :<%= table_name.singularize %>_id
			t.decimal :price, :null => false, :default => 0.0
			t.string :units, :null => false, :default => "USD"
			t.timestamps
		end # create_table
		add_index :<%= table_name.singularize %>_bids, :<%= table_name %>_id
		add_index :<%= table_name.singularize %>_bids, [:<%= table_name.singularize %>_id, :id], :unique => true 
	end # change
end # AuctionHouseCreate<%= table_name.camelize %>
