class AddMawToItems < ActiveRecord::Migration
  def change
    add_column :items, :maw, :decimal
  end
end
