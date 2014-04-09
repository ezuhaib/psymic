class CreateComics < ActiveRecord::Migration
  def change
    create_table :comics do |t|
      t.string :title
      t.integer :mindlog_id
      t.integer :user_id
      t.integer :likes_count

      t.timestamps
    end
  end
end
