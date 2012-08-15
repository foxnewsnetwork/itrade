class AddExpirationToServices < ActiveRecord::Migration
  def change
    add_column :services, :expiration, :datetime
  end
end
