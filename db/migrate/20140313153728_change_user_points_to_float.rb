class ChangeUserPointsToFloat < ActiveRecord::Migration
  def up
  	change_column :users, :points, :float
  	User.all do |u|
  		u.update_points
  	end
  end
end
