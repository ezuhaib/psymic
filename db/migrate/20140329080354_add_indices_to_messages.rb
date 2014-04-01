class AddIndicesToMessages < ActiveRecord::Migration
  def change
  	add_index :messages, [:read,:mailed]
  	add_index :messages, [:sender_id,:recipient_id]
  end
end
