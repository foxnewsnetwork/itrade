class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :quantity, :default => 0
      t.string :units, :default => "kg"
      t.string :title, :default => "No title"
      t.text :description

      t.timestamps
    end # create_table
  end # change
end # CreateItems
