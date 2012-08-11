class CreateTrucks < ActiveRecord::Migration
  def change
    create_table :trucks do |t|
      t.string :company, :null => false
      t.integer :start, :null => false
      t.integer :finish, :null => false
      t.decimal :price, :null => false, :default => 0.0

      t.timestamps
    end # trucks table
    add_index :trucks, :company
    add_index :trucks, [:start, :finish]
  end # change
end # trucks
