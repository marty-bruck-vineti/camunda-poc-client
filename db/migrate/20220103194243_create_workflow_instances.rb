class CreateWorkflowInstances < ActiveRecord::Migration[6.1]
  def change
    create_table :workflow_instances do |t|
      t.string "internal_id", :limit => 128, :null => false
      t.string "name", :limit => 128, :null => false
      t.boolean "active", :default => false
      t.timestamps
    end
  end
end
