class CreateTargets < ActiveRecord::Migration
  def change
    create_table :targets do |t|
      t.integer :t_id
      t.string :t_type

      t.timestamps
    end # table
    add_index :targets, [:t_id, :t_type], :unique => true
  end # change
end
