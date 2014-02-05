class UsersController < ApplicationController
  def show
  	@user = User.find(params[:id])
    authorize! :read , @user
  end

  def index
    @users = User.all
  end

  def edit
  	@user = User.find_by_id(params[:id])
    authorize! :update , @user
  end

  def update
  	@user = User.find(params[:id])
    authorize! :update , @user
    
	  if @user.update_attributes(params[:user])
        redirect_to @user, notice: 'Profile was successfully updated.'
      else
        render action: "edit"
      end
  end

  def mindlogs
    @user = User.find(params[:id])
    @mindlogs = @user.mindlogs
  end

  def profile
    @user = current_user
    render :show
  end

  def profile_edit
    @user = current_user
    authorize! :update , @user
    render :edit
  end

end
