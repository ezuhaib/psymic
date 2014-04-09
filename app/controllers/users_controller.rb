class UsersController < ApplicationController
  before_filter :fetch_user , only: [:show,:edit,:update,:mindlogs,:activity]
  before_filter :fetch_profile , only: [:avatar,:crop,:profile_edit,:update_avatar]

  def fetch_user
    @user = User.find_by_username(params[:id])
  end

  def fetch_profile
    if params[:username]
      @user = User.find_by_username(params[:username])
    else
      @user = current_user
    end
    authorize! :update , @user
  end

  def show
    authorize! :read , @user
    @page_title = "USER: #{@user.username}"
    @mindlogs = @user.mindlogs.published.limit(5)
    @pending_mindlogs = @user.mindlogs.queued
    @pending_comics = @user.comics.queued
  end

  def index
    authorize! :read , User
    @page_title = "Users"
    @users = User.order('points desc').page(params[:page])
  end

  def edit
    authorize! :update , @user
  end

  def avatar
    @page_title = "Edit avatar"
  end

  def update_avatar
    if !params[:user]
      flash[:alert] = 'Please select an image file first'
      render 'avatar'
    elsif params[:user][:avatar] && @user.update_attributes(params[:user])
      redirect_to action: :crop
    elsif params[:do] == 'crop' && @user.update_attributes(params[:user])
      redirect_to edit_profile_path , notice:"Avatar successfully updated"
    else
      flash[:alert] = 'Some error occured'
      render 'avatar'
    end
  end

  def update
    authorize! :update , @user

	  if @user.update_attributes(params[:user])
        if params[:user] && params[:user][:avatar]
          redirect_to action: :crop
        else
          redirect_to @user, notice: 'Profile was successfully updated.'
        end
      else
        render action: "edit"
      end
  end

  def crop
    @page_title = "Crop Avatar"
  end

  def mindlogs
    @mindlogs = @user.mindlogs.published
    @page_title = "#{@user.username}'s mindlogs"
  end

  def profile
    authorize! :authenticate, :psymic
    @user = current_user
    @mindlogs = @user.mindlogs.published.limit(5)
    render :show
  end

  def profile_edit
    render :edit
  end

  def activity
    @page_title = "#{@user.username} activity"
  end

  def autocomplete
    @users = ""
    if params[:qb]
      @users = User.where("users.username LIKE ?", "#{params[:qb]}%").limit(4).map{|t| {:id => t.id, :username => t.username }}
    elsif params[:q] and params[:q].size > 1
      @users = User.where("users.username LIKE ?", "#{params[:q]}%").limit(4).pluck(:username)
    end
    render json: @users
  end

end
