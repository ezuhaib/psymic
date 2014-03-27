class AddReadMarksToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :mailed, :boolean, default: false
    add_column :activities, :read, :boolean, default: false
  end
end
