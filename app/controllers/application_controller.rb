class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authorize_mini_profiler

  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      flash[:error] = "You are not authorized to access this page"
      redirect_to root_path
    else
      flash[:error] = "Must login first"
      session[:user_return_to] = request.fullpath
      redirect_to user_session_path
    end
  end

  def not_found()
    raise ActionController::RoutingError.new('Not Found')
  end

	def authorize_mini_profiler
		if can? :monitor , :all
  		Rack::MiniProfiler.authorize_request
		end
  end

  # returns array of valid ids of users mentioned in the given text
  def extract_mentions( text )
    regex = /(?:^|\s)@(\w*)(?:\s|\z|$)/
    usernames_array = text.scan(regex).flatten
    ids = User.where(username: usernames_array).pluck(:id) - [current_user.id] if usernames_array
    ids.blank? ? false : ids
  end

end