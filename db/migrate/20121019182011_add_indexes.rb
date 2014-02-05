class AddIndexes < ActiveRecord::Migration
  def up
	add_index :mindlogs, :tag
  add_index :mlexamples, :mindlog_id
	add_index :mlexplanations, :mindlog_id
  end

  def down
  end
end
