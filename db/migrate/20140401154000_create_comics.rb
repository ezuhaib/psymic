class CreateComics < ActiveRecord::Migration
  def change
    create_table :comics do |t|
      t.string :caption
      t.integer :mindlog_id
      t.integer :user_id
      t.integer :likes_count

      t.timestamps
    end
  end
end
