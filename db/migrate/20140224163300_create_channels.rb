class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :title
      t.string :slug
      t.text :body
      t.string :query

      t.timestamps
    end
  end
end
