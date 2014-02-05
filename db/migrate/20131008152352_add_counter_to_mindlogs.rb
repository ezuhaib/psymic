class AddCounterToMindlogs < ActiveRecord::Migration
  def change
    add_column :mindlogs, :counter, :integer
  end
end
