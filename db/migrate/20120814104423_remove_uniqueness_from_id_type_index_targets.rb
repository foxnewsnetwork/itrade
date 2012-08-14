class RemoveUniquenessFromIdTypeIndexTargets < ActiveRecord::Migration
  def up
  	remove_index :targets, [:t_id, :t_type]
  	add_index :targets, [:t_id, :t_type]
  end

  def down
  	remove_index :targets, [:t_id, :t_type]
  	add_index :targets, [:t_id, :t_type], :unique => true
  end
end
