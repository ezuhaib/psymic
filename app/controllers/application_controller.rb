class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :authorize_mini_profiler, :record_signup_redirect_path, :record_user_activity
  before_action :configure_permitted_parameters, if: :devise_controller?

  # The purpose of below is to flash errors rather than cancan's
  # default of loading an "access denied" exception

  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      flash[:error] = "You are not authorized to access this page"
      redirect_to root_path
    else
      flash[:error] = "Must login first"
      redirect_to user_session_path
    end
  end

  ##################################
  public
  ##################################

  def not_found()
    raise ActionController::RoutingError.new('Not Found')
  end

  # returns array of valid ids of users mentioned in the given text
  def extract_mentions( text )
    regex = /(?:^|\s)@(\w*)(?:\s|\z|$)/
    usernames_array = text.scan(regex).flatten
    ids = User.where(username: usernames_array).pluck(:id) - [current_user.id] if usernames_array
    ids.blank? ? false : ids
  end

  def uname(id)
    User.select(:username).find(id)
  end

  ###########################################
  private
  ###########################################

  # For authenticated users, the time of each page request 
  # is saved in the user table in the database. The purpose
  # is to make "last_active_at" stats available in user's
  # profile.

  def record_user_activity
    current_user.touch :last_active_at if current_user
  end

  # For unauthenticated users, reference to each page request
  # is saved in the session so that upon sign-in user is 
  # correctly referred to the last page he was on.

  def record_signup_redirect_path
    return if current_user and !request.get? 
    if (request.path != "/account/login" &&
        request.path != "/account/register" &&
        request.path != "/account/password/new" &&
        request.path != "/account/logout" &&
        !request.xhr?) # don't store ajax calls
      session[:user_return_to] = request.fullpath
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) << :email << User.option_params
    devise_parameter_sanitizer.for(:sign_up) << User.profile_params
  end

  # Ensures that miniprofiler is loaded only for admins
  def authorize_mini_profiler
    if can? :monitor , :all
      Rack::MiniProfiler.authorize_request
    end
  end

end