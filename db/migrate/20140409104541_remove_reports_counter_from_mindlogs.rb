class RemoveReportsCounterFromMindlogs < ActiveRecord::Migration
  def up
    remove_column :mindlogs, :reports_counter
  end

  def down
    add_column :mindlogs, :reports_counter, :integer
  end
end
