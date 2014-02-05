class AddUserIdToMindlogs < ActiveRecord::Migration
  def change
    add_column :mindlogs, :user_id, :integer
  end
end
