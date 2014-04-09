class AddReadMarksIndicesToActivities < ActiveRecord::Migration
  def self.up
    add_index :activities, [:read,:mailed]
  end

  def self.down
    remove_index :activities, [:read,:mailed]
  end
end
