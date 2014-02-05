class AddStasusToMindlogs < ActiveRecord::Migration
  def change
    add_column :mindlogs, :stasus, :text
  end
end
