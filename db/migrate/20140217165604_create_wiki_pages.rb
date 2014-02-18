class CreateWikiPages < ActiveRecord::Migration
  def change
    create_table :wiki_pages do |t|
      t.string :title
      t.text :body
      t.integer :user_id

      t.timestamps
    end
  end
end
