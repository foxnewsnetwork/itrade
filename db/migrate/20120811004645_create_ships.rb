class CreateShips < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.string :company, :null => false
      t.integer :start, :null => false
      t.integer :finish, :null => false
      t.decimal :price, :null => false, :default => 0.0

      t.timestamps
    end # create_table
    add_index :ships, :company
    add_index :ships, [:start, :finish]
  end # change
end # ships
