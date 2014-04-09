class AddPairingToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :pairing, :string
    add_index :messages, :pairing
  end
end
