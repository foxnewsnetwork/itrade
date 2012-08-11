class CreateAuxiliaries < ActiveRecord::Migration
  def change
    create_table :auxiliaries do |t|
      t.integer :bid_id, :null => false
      t.integer :s_id, :null => false
      t.string :s_type, :null => false

      t.timestamps
    end # create_table
    add_index :auxiliaries, :bid_id
    add_index :auxiliaries, [:s_id, :s_type]
    add_index :auxiliaries, [:bid_id, :s_id, :s_type], :unique => true
  end # change
end	# Auxiliaries
