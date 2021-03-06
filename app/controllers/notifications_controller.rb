class NotificationsController < ApplicationController
  def index
    authorize! :read , :notification
    @page_title = "Notifications"
  	@subscriptions = Subscription.where("user_id=? AND counter>= ?",current_user.id,1)
    @activities = PublicActivity::Activity.where(:recipient_id => current_user.id).order('created_at desc').page(params[:page])
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
