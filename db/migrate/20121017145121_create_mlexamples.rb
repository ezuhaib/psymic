class CreateMlExamples < ActiveRecord::Migration

  def change
    create_table :mlexamples do |t|
      t.string :description
      t.integer :mindlog_id

      t.timestamps
    end
  end
end
