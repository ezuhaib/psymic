class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authorize_mini_profiler

  rescue_from CanCan::AccessDenied do |exception|
  	flash[:error] = "Access Denied"
  	redirect_to root_url
  end

  def not_found()
    raise ActionController::RoutingError.new('Not Found')
  end

	def authorize_mini_profiler
		if can? :monitor , :all
  		Rack::MiniProfiler.authorize_request
		end
  end

end