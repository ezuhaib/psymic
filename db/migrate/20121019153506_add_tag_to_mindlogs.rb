class AddTagToMindlogs < ActiveRecord::Migration
  def change
    add_column :mindlogs, :tag, :string
  end
end
