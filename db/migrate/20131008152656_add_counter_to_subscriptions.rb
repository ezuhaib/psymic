class AddCounterToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :counter, :integer
  end
end
