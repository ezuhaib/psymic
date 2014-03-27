class CreateMindlogRatings < ActiveRecord::Migration
  def change
    create_table :mindlog_ratings do |t|
      t.integer :mindlog_id
      t.integer :user_id
      t.integer :rating

      t.timestamps
    end
  end
end
