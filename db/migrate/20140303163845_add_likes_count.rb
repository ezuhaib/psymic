class AddLikesCount < ActiveRecord::Migration
  def self.up
    add_column :mindlogs, :likes_count, :integer, :default => 0

    Mindlog.reset_column_information
    Mindlog.all.each do |m|
      m.update_attribute :likes_count, m.likes.length
    end
  end

  def self.down
    remove_column :mindlogs, :likes_count
  end
end
