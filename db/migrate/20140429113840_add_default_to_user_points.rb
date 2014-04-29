class AddDefaultToUserPoints < ActiveRecord::Migration
  def change
  	change_column_default :users, :points, 0
  	User.where(points: nil).each do |u|
  		u.update_attribute(:points, 0)
  	end
  end
end
