class PagesController < ApplicationController

  def root
      if !current_user
        @mindlogs = Mindlog.published.limit(6).all
        @mindlogs_count = Mindlog.published.count
      else
        authorize! :read , Mindlog
        if !params[:sort] or params[:sort] == "date"
          @order = {created_at: :desc}
          @order_sql = "created_at DESC"
        elsif params[:sort] == "popular"
          @order = {likes_count: :desc}
          @order_sql = "created_at DESC"
        elsif params[:sort] == "lonely"
          @order = {created_at: :desc}
          @order_sql = "created_at DESC"
        else
        end

        if params[:query].present?
          @mindlogs = Mindlog.search(params[:query], where:{workflow_state:"published"}, order: @order , page: params[:page], fields: [:title] , highlight:{tag: "<strong>"})
          @has_details = true
          @title = "Searching mindlogs"
        elsif params[:tag]
          @mindlogs = Mindlog.published.tagged_with(params[:tag]).order(@order_sql).page(params[:page])
          @title = "tag: ##{params[:tag]}"
        else
          @mindlogs = Mindlog.search("*", where:{workflow_state:"published"}, order: @order, page: params[:page] , per_page:20)
          @title = "Mindlogs"
        end

        @mindlog = Mindlog.new
        respond_to do |format|
          format.html { render 'mindlogs/index'}
          format.json { render json: @mindlogs }
        end
      end
  end

  def confirm_email
  end

  def not_found
  end

  def error
  end

end