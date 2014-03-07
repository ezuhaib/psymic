class Admin::PagesController < ApplicationController
  def index
    authorize! :manage, :all
    @mindlogs_count = Mindlog.where(workflow_state: ['awaiting_review','unpublished']).count
    @users_count = User.unread_by(current_user).count
  end

  def backstage
  	authorize! :backstage, Feedback
    @feedback = Feedback.new
    @feedbacks = Feedback.backstage.order("created_at DESC").page(params[:page])
  end

end
