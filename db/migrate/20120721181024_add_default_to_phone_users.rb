class AddDefaultToPhoneUsers < ActiveRecord::Migration
  def up
  	remove_column :users, :phone
    add_column :users, :phone, :string, :null => false, :default => ""
    add_column :users, :extention, :string
  end # up
  def down
  	remove_column :users, :extension
  end # down
end # AddDefault
