class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :user_id
      t.string :subscribable_type
      t.string :subscribable_id

      t.timestamps
    end
  end
end
