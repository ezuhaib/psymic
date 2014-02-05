class CreateMindlogs < ActiveRecord::Migration
  def change
    create_table :mindlogs do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
