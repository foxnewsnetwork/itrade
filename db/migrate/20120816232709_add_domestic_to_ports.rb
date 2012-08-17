class AddDomesticToPorts < ActiveRecord::Migration
  def change
    add_column :ports, :domestic, :boolean, :null => false, :default => true
  end # change
end # AddDomesticToPorts
