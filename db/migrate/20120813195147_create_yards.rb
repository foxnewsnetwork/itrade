class CreateYards < ActiveRecord::Migration
  def change
    create_table :yards do |t|
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zip

      t.timestamps
    end
  end
end
