class CreateStasus < ActiveRecord::Migration
  def change
    create_table :stasus do |t|
      t.string :title
      t.string :colour

      t.timestamps
    end
  end
end
