class CreateSynapsedefs < ActiveRecord::Migration
  def change
    create_table :synapsedefs do |t|
      t.string :synapse
      t.string :class
      t.text :def

      t.timestamps
    end
  end
end
