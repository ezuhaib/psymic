class Admin::PagesController < ApplicationController
  def index
    authorize! :manage, :all
    @page_title = "Admin"
    @reports_count = Report.where(reportable_type: "Mindlog").count('reportable_id',distinct: true)
    @mindlogs_count = Mindlog.where(workflow_state: ['awaiting_review','unpublished']).count
    @users_count = User.unread_by(current_user).count
    @comics_count = Comic.where("status != ?",'published').count
    @channel_items_count = ChannelItem.where(item_type:"Mindlog", status:"pending").count
  end

  def backstage
  	authorize! :backstage, Feedback
    @page_title = "Backstage"
    @feedback = Feedback.new
    @feedbacks = Feedback.backstage.order("created_at DESC").page(params[:page])
  end

  def users
    @page_title = "Users listing"
    if params[:do] and params[:do] == "mark_read"
      User.mark_as_read! :all, :for => current_user
      redirect_to users_path
    end
    authorize! :update , User
    @users = User.with_read_marks_for(current_user).order('created_at desc').page(params[:page])
  end

  def comics
    @page_title = "Comics Moderation"
    authorize! :moderate , Comic
    @comics = Comic.where("status != ?",'published')
  end

  def channel_items
    authorize! :moderate, Channel
    @items = ChannelItem.where(item_type:"Mindlog", status:"pending").page(params[:page])
  end

end
