class SubscriptionsController < ApplicationController

def index
  @page_title = "Watchlist"
	@subscriptions = Subscription.where(:user_id=>current_user.id).order("counter desc")
end

  def destroy
	@subscription = Subscription.find(params[:id])
  	@subscription.destroy
	respond_to do |format|
	format.html {redirect_to :back}
	format.js #added
	end	
  end

  def clear
  	@subscriptions = Subscription.where(:user_id=>current_user.id).all
  	@subscriptions.each do |s|
  		s.counter = 0
  		s.save
  	end
  	redirect_to :back
  end

end