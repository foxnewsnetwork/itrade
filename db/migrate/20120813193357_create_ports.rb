class CreatePorts < ActiveRecord::Migration
  def change
    create_table :ports do |t|
      t.string :city
      t.string :code

      t.timestamps
    end # table 
    add_index :ports, :code, :unique => true
    add_index :ports, :city
  end # change
end # ports
