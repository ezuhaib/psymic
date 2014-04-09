class PutDefaultsOnLikesCountInComics < ActiveRecord::Migration
  def change
  	change_column_default :comics, :likes_count, 0
  end
end
