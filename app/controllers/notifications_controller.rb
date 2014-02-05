class NotificationsController < ApplicationController
  def index
  	@notifications = Notification.where(:user_id=>current_user.id).order("updated_at DESC")
  	@subscriptions = Subscription.find(:all, :conditions=>["user_id=? AND counter>= ?",current_user.id,1])
  end

  def clear
  	@notifications = Notification.where(:user_id=>current_user.id).all
  	@notifications.each do |n|
  		n.counter = 0
  		n.save
  	end
  	redirect_to :back
  end

end
