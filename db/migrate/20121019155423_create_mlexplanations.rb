class CreateMlexplanations < ActiveRecord::Migration
  def change
    create_table :mlexplanations do |t|
      t.text :body
      t.integer :mindlog_id

      t.timestamps
    end
  end
end
