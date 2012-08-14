class RemoveNullFalseFromShipsTrucks < ActiveRecord::Migration
  def up
  	drop_table :trucks
  	drop_table :ships
  	create_table :trucks do |t|
      t.string :company, :null => false
      t.integer :start
      t.integer :finish 
      t.decimal :price, :null => false, :default => 0.0

      t.timestamps
    end # trucks table
    add_index :trucks, :company
    add_index :trucks, [:start, :finish]
    create_table :ships do |t|
      t.string :company, :null => false
      t.integer :start
      t.integer :finish
      t.decimal :price, :null => false, :default => 0.0

      t.timestamps
    end # create_table
    add_index :ships, :company
    add_index :ships, [:start, :finish]
  end # down
  
  def down
  	drop_table :trucks
  	drop_table :ships
  	create_table :trucks do |t|
      t.string :company, :null => false
      t.integer :start, :null => false
      t.integer :finish, :null => false
      t.decimal :price, :null => false, :default => 0.0

      t.timestamps
    end # trucks table
    add_index :trucks, :company
    add_index :trucks, [:start, :finish]
    create_table :ships do |t|
      t.string :company, :null => false
      t.integer :start, :null => false
      t.integer :finish, :null => false
      t.decimal :price, :null => false, :default => 0.0

      t.timestamps
    end # create_table
    add_index :ships, :company
    add_index :ships, [:start, :finish]
  end # down
end # RemoveNull...
