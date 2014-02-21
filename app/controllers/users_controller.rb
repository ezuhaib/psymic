class UsersController < ApplicationController
  before_filter :fetch_user , only: [:show,:edit,:update,:mindlogs]

  def fetch_user
    @user = User.find_by_username(params[:id])
  end

  def show
    authorize! :read , @user
  end

  def index
    @users = User.all
  end

  def edit
    authorize! :update , @user
  end

  def update
    authorize! :update , @user

	  if @user.update_attributes(params[:user])
        redirect_to @user, notice: 'Profile was successfully updated.'
      else
        render action: "edit"
      end
  end

  def mindlogs
    @mindlogs = @user.mindlogs
  end

  def profile
    @user = current_user
    render :show
  end

  def profile_edit
    if params[:user]
      @user = User.find_by_username(params[:user])
    else
      @user = current_user
    end
    authorize! :update , @user
    render :edit
  end

end
