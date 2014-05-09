class MindlogsController < ApplicationController

  def index
    authorize_and_sort_mindlogs
    @page_title       = 'Psymic Mindlogs'
    @page_description = 'Mindlogs are logs of community-reported observations of human behavior.'
    @mindlogs = Mindlog.search("*", where:{workflow_state:"published"}, order: @order, page: params[:page] , per_page:20)
    @mindlog = flash[:mindlog] ? Mindlog.create(flash[:mindlog].permit(:description, :title , :topic_list, :review)) : Mindlog.new
  end

  def search
    authorize_and_sort_mindlogs(default_sort: :relevance)
    @page_title = "Searching #{params[:query]} in mindlogs"
    @mindlogs = Mindlog.search(params[:query], where:{workflow_state:"published"}, order: @order , page: params[:page], fields: [:title,:tags_name] , highlight:{tag: "<strong>"})
    @has_details = true
  end

  def tag
    authorize_and_sort_mindlogs
    @page_title = "Mindlogs tagged ##{params[:tag]}"
    @mindlogs = Mindlog.published.tagged_with(params[:tag]).order(@order).page(params[:page])
  end

  def search_redirect
    if params[:query].present?
      redirect_to search_mindlogs_path(query: params[:query])
    end
  end

  def show
    @mindlog = Mindlog.find(params[:id])
    @page_title = @mindlog.title
    @page_description = ActionController::Base.helpers.strip_tags(@mindlog.description)
    @channels = @mindlog.channels

    authorize! :read , @mindlog
    authorize! :read_unpublished , @mindlog if @mindlog.workflow_state != "published"

    load_responses
  end

  def moderate
    @mindlog = Mindlog.find(params[:id])
    authorize! :moderate , @mindlog
    if params[:task] == "toggle_feature"
      @mindlog.toggle_feature(current_user.id)
      flash[:notice] = "Featuring action successful"
    elsif params[:task] == "toggle_publish"
      @mindlog.state?(:published) ? @mindlog.state(:unpublished) : @mindlog.state(:published)
      flash[:notice] = "Publishing action successful"
    end
    redirect_to action: :show
  end

  def new
    @page_title = "New Mindlog"
    @mindlog = Mindlog.new
    authorize! :create , @mindlog
  end

  def edit
    @mindlog = Mindlog.find(params[:id])
    @page_title = "Editing '#{@mindlog.title}'"
    authorize! :update , @mindlog
  end

  def create
    @mindlog = Mindlog.new(mindlog_params)
    @mindlog.user = current_user
    authorize! :create , @mindlog
    if @mindlog.save
      (params[:submit_only]||params[:mindlog][:review] == '1') ? @mindlog.state(:awaiting_review) : @mindlog.state(:published)
      Mindlog.searchkick_index.refresh
      redirect_to mindlogs_path, notice: 'Mindlog was successfully created.'
    else
      flash[:error] = @mindlog.errors.full_messages.join('</br>').html_safe
      flash[:mindlog] = params[:mindlog]
      redirect_to :back
    end
  end

  def update
    @mindlog = Mindlog.find(params[:id])
    authorize! :update , @mindlog
    @mindlog.assign_attributes(mindlog_params)
    @changed = @mindlog.changed?
    if @mindlog.save

      # Publish
      if params[:publish]
        authorize! :publish , @mindlog
        @prev_state = @mindlog.workflow_state
        @mindlog.state(:published)
      end

      # add appropriate activity/notification
      @key = :update if @changed and @mindlog.state?(:published)
      @key = :publish if @prev_state == 'awaiting_review'
      @key = :update_and_publish if @changed and @prev_state == 'awaiting_review'
      if @key
        @mindlog.create_activity @key , recipient: @mindlog.user , owner: current_user unless @mindlog.user == current_user
      end
      redirect_to @mindlog, notice: 'Mindlog was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @mindlog = Mindlog.find(params[:id])
    authorize! :destroy , @mindlog
    @mindlog.destroy
    Mindlog.searchkick_index.refresh
    redirect_to mindlogs_url , notice: "Deleted Mindlog successfully"
  end

  def report
    @mindlog = Mindlog.find(params[:id])
    authorize! :report , @mindlog
    @page_title = "Report"
    if params[:flag]
      @report = @mindlog.reports.new
      @report.user = current_user
      @report.flag_id = params[:flag]
      if @report.save
        flash[:success] = "Content successfully reported"
      else
        flash[:error] = @report.errors.full_messages.first
      end

      respond_to do |format|
        format.html { redirect_to @mindlog and return}
        format.js #added
      end
    end
  end

  def reports
    @page_title = "Report"
  end


  def subscribe
  @mindlog = Mindlog.find(params[:id])
  authorize! :subscribe , @mindlog
  @subscription = Subscription.new
  @subscription.subscribable = @mindlog
  @subscription.user_id = current_user.id
    if @subscription.save
      redirect_to @mindlog , flash: {success:"Subscribed successfully"}
    else
      redirect_to @mindlog , flash: {error: "Couldn't Subscribe"}
    end
  end

  def unsubscribe
    @mindlog = Mindlog.find(params[:id])
    authorize! :unsubscribe , @mindlog
    @subscription = @mindlog.subscriptions.find_by_user_id(current_user.id)
      if @subscription.destroy
        redirect_to @mindlog , flash: {success:  "Unsubscribed successfully"}
      else
        redirect_to @mindlog , flash: {error: "Couldn't Unsubscribe"}
      end
  end

def moderation_queue
  @mindlogs = Mindlog.queued
  @page_title = "Mindlogs Queue"
end

  # Regex ensures strings starting with '#' are ignored
  def autocomplete
      unless /\A#.+/.match(params[:query])
        @mindlogs = Mindlog.search(params[:query], where:{workflow_state:"published"},fields: [:title,{title: :text_start}], limit: 10).as_json(only:[:id,:title]) 
      end
    render json: @mindlogs
  end

  # Using Jbuilder, stripping leading #'s from query strings
  # Query with 'q' for vanilla queries that have noyhing to do with #'s
  def autocomplete_tags
    if params[:query]
      @tags = Mindlog.published.topic_counts.where('name LIKE ?',"#{params[:query].delete("#")}%")
    end
  end

  # For selctize. Using seperate function because we donot need to strip or append #'s
  def tags
    return false if params[:q] and params[:q].size < 3
    @tags = ActsAsTaggableOn::Tag.where("tags.name LIKE ?", "%#{params[:q]}%") 
    respond_to do |format|
      format.json { render :json => @tags.map{|t| {:id => t.name, :name => t.name }}}
    end
  end

  def rate
    authorize! :rate , Mindlog
    @mindlog = Mindlog.find(params[:id])
    if params[:value]
      @rating = params[:value]
      @mindlog_rating = MindlogRating.where(mindlog_id: @mindlog.id, user_id: current_user.id).first_or_create
      @mindlog_rating.update_attribute(:rating, @rating)
      @updated = true
    end
    respond_to do |format|
      format.js #added
      format.html {redirect_to @mindlog}
    end
  end

  def channel_selection
    @mindlog = Mindlog.find(params[:id])
  end

  def resolve
    @mindlog = Mindlog.find(params[:id])
    if @mindlog.reports.destroy_all
      flash[:success] = "Issues resolved"
      redirect_to admin_reports_index_path
    else
      flash[:error] = "An error occured. Webmasters have been notified"
      @back = request.env["HTTP_REFERER"] || admin_report_path('mindlog',@mindlog.id)
      redirect_to @back
    end
  end

  private
  
  def mindlog_params
    params.require(:mindlog).permit(:description, :title , :topic_list , :status, :workflow_state, :review , :channel_id)
  end
  
  def authorize_and_sort_mindlogs(options={})
    authorize! :read , Mindlog

    if params[:sort]
      sort = params[:sort].to_sym
    elsif options[:default_sort]
      sort = options[:default_sort].to_sym
    else
      sort = :date
    end

    @order = case sort
    when :date
      {created_at: :desc}
    when :popular
      {responses_count: :desc}
    when :lonely
      {responses_count: :asc}
    when :relevance
      {_score: :desc}
    end
  end

  def load_responses
    if params[:response]
      @response = Response.find(params[:response])
      @page_title = "Mindlog: Single response to: #{@mindlog.title}"
      render "single_response"
    end

    @responses = case params[:only].try(:to_sym)
    when :explanation , :solution , :critique , :story
      @mindlog.responses.where(nature: params[:only]).order("rating DESC")
    else
      @mindlog.responses.order("created_at DESC")
    end

    @response = @mindlog.responses.new
    @responses = @responses.page(params[:page]).per(10)
  end
end
