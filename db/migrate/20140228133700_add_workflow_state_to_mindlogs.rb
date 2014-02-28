class AddWorkflowStateToMindlogs < ActiveRecord::Migration
  def change
    add_column :mindlogs, :workflow_state, :string
  end
end
