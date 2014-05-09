class AddResponsesCountToMindlogs < ActiveRecord::Migration
  def change
    add_column :mindlogs, :responses_count, :integer
    Mindlog.all.each do |m|
    	Mindlog.reset_counters m.id, :responses
    end
  end
end
