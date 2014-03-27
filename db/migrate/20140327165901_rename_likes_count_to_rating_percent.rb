class RenameLikesCountToRatingPercent < ActiveRecord::Migration
  def change
    rename_column :mindlogs, :likes_count, :rating_percent
  end
end
