class AddIndexToCompanyInUsers < ActiveRecord::Migration
  def change
  	add_index :users, :company
  end # change
end # AddIndexToCompanyInUsers
