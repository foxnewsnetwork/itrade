class AddUserIdToBids < ActiveRecord::Migration
  def change
    add_column :bids, :user_id, :integer
    add_index :bids, :user_id
  end # def change
end
