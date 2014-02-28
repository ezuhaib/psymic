class CreateFeaturedMindlogs < ActiveRecord::Migration
  def change
    create_table :featured_mindlogs do |t|
      t.integer :mindlog_id
      t.integer :moderator_id

      t.timestamps
    end
  end
end
