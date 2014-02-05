class AddScopeToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :scope, :string
  end
end
