class CreateChannelItems < ActiveRecord::Migration
  def change
    create_table :channel_items do |t|
      t.string :item_type
      t.integer :item_id
      t.integer :channel_id
      t.string :status , default: "pending"
      t.integer :submitter_id

      t.timestamps
    end
    add_index :channel_items , [:item_type,:item_id]
    add_index :channel_items , :channel_id
  end
end
