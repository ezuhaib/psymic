class Admin::PagesController < ApplicationController
  def index
    authorize! :manage, :all
  end

  def backstage
  	authorize! :backstage, Feedback
    @feedback = Feedback.new
    @feedbacks = Feedback.backstage.order("created_at DESC").page(params[:page])
  end

end
