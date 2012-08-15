class AddExpirationToShips < ActiveRecord::Migration
  def change
    add_column :ships, :expiration, :datetime
  end
end
