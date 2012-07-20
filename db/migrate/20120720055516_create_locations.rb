class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :address
      t.string :city
      t.string :state
      t.string :name
      t.string :country
      t.string :zip

      t.timestamps
    end
  end
end
