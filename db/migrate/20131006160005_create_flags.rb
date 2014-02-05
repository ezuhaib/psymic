class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.string :title

      t.timestamps
    end
  end
end
