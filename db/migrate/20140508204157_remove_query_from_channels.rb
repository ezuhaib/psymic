class RemoveQueryFromChannels < ActiveRecord::Migration
  def change
    remove_column :channels, :query, :string
  end
end
