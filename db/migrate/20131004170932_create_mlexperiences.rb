class CreateMlexperiences < ActiveRecord::Migration
  def change
    create_table :mlexperiences do |t|
      t.integer :user_id
      t.text :body

      t.timestamps
    end
  end
end
