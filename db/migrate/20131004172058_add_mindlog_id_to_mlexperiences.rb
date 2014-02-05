class AddMindlogIdToMlexperiences < ActiveRecord::Migration
  def change
    add_column :mlexperiences, :mindlog_id, :integer
  end
end
