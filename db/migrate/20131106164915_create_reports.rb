class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :flag_id
      t.integer :user_id
      t.string :reportable_type
      t.integer :reportable_id

      t.timestamps
    end
  end
end
