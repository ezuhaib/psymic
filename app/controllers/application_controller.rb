class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from CanCan::AccessDenied do |exception|
  	flash[:error] = "Access Denied"
  	redirect_to root_url
  end
  before_filter :authorize_mini_profiler
  	def authorize_mini_profiler
  		if can? :monitor , :all
    		Rack::MiniProfiler.authorize_request
  		end
	end

end