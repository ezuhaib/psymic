class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :layout_by_resource
  before_filter :authorize_mini_profiler

  rescue_from CanCan::AccessDenied do |exception|
  	flash[:error] = "Access Denied"
  	redirect_to root_url
  end

	def authorize_mini_profiler
		if can? :monitor , :all
  		Rack::MiniProfiler.authorize_request
		end
  end


  def layout_by_resource
    if devise_controller? && !current_user
      "walled_garden"
    else
      "application"
    end
  end

end