class Admin::PagesController < ApplicationController
  def index
    authorize! :manage, :all
  end

  def backstage
  	authorize! :backstage, Feedback
    @feedback = Feedback.new
    @feedbacks = Feedback.backstage.page(params[:page])
  end

end
