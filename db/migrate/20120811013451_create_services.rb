class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :company, :null => false, :default => "Tracago"
      t.string :title, :null => false
      t.string :description, :null => false
      t.decimal :price, :null => false, :default => 0.0

      t.timestamps
    end # services table
    add_index :services, :title
    add_index :services, :company
  end # change
end # create services
