class AddExpirationToTrucks < ActiveRecord::Migration
  def change
    add_column :trucks, :expiration, :datetime
  end
end
