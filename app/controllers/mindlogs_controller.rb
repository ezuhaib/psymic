class MindlogsController < ApplicationController

  # GET /mindlogs/1
  # GET /mindlogs/1.json

  def index
    authorize! :read , Mindlog
    if params[:sort] == "popular"
      @order = {likes_count: :desc}
      @order_sql = "created_at DESC"
    elsif params[:sort] == "lonely"
      @order = {created_at: :desc}
      @order_sql = "created_at DESC"
    else
    end
    if params[:query].present?
      @order = {_score: :desc} if !params[:sort] or params[:sort] == "date"
      @mindlogs = Mindlog.search(params[:query], where:{workflow_state:"published"}, order: @order , page: params[:page], fields: [:title,:tags_name] , highlight:{tag: "<strong>"})
      @has_details = true
      @title = "Searching mindlogs"
    elsif params[:tag]
      @order_sql = "created_at DESC" if !params[:sort] or params[:sort] == "date"
      @mindlogs = Mindlog.published.tagged_with(params[:tag]).order(@order_sql).page(params[:page])
      @title = "tag: ##{params[:tag]}"
    else
      @order = {created_at: :desc} if !params[:sort] or params[:sort] == "date"
      @mindlogs = Mindlog.search("*", where:{workflow_state:"published"}, order: @order, page: params[:page] , per_page:20)
      @title = "Mindlogs"
    end
    @mindlog = flash[:mindlog] ? Mindlog.create(flash[:mindlog]) : Mindlog.new
    @top_users = User.order('points desc').limit(5)
    respond_to do |format|
      format.html { render 'mindlogs/index'}
      format.json { render json: @mindlogs }
    end
  end

  def show
    @mindlog = Mindlog.find(params[:id])
    @mindlog.status = "None yet." if @mindlog.status.blank?
    authorize! :read , @mindlog
    if params[:response]
      @response = Response.find(params[:response])
      render "single_response"
    end

    if params[:only] == "explanations"
      @responses = @mindlog.responses.where(nature:"explanation").order("rating DESC")
    elsif params[:only] == "solutions"
      @responses = @mindlog.responses.where(nature:"solution").order("rating DESC")
    elsif params[:only] == "critiques"
      @responses = @mindlog.responses.where(nature:"critique").order("rating DESC")
    elsif params[:only] == "stories"
      @responses = @mindlog.responses.where(nature:"story").order("rating DESC")
    else
      if params[:do] == "toggle_feature"
        authorize! :moderate , @mindlog
        flash[:notice] = "Featuring action successful" if @mindlog.toggle_feature(current_user.id)
      elsif params[:do] == "toggle_publish"
        @mindlog.state?(:published) ? @mindlog.state(:unpublished) : @mindlog.state(:published)
        flash[:notice] = "Publishing action successful"
      end
	     @responses = @mindlog.responses.order("created_at DESC")
    end
    @response = @mindlog.responses.new
    @responses = @responses.page(params[:page]).per(10)
    redirect_to action: :show if params[:do] #to get rid of args in url
  end

  # GET /mindlogs/new
  # GET /mindlogs/new.json
  def new
    @mindlog = Mindlog.new
    authorize! :create , @mindlog
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mindlog }
    end
  end

  # GET /mindlogs/1/edit
  def edit
    @mindlog = Mindlog.find(params[:id])
    authorize! :update , @mindlog
  end

  # POST /mindlogs
  # POST /mindlogs.json
  def create
    @mindlog = Mindlog.new(params[:mindlog])
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

  # PUT /mindlogs/1
  # PUT /mindlogs/1.json
  def update
    @mindlog = Mindlog.find(params[:id])
    authorize! :update , @mindlog
    @mindlog.assign_attributes(params[:mindlog])
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
        @mindlog.create_activity @key , recipient: @mindlog.user , owner: current_user
      end
      redirect_to @mindlog, notice: 'Mindlog was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /mindlogs/1
  # DELETE /mindlogs/1.json
  def destroy
    @mindlog = Mindlog.find(params[:id])
    authorize! :destroy , @mindlog
    @mindlog.destroy
    Mindlog.searchkick_index.refresh
    respond_to do |format|
      format.html { redirect_to mindlogs_url }
      format.json { head :no_content }
    end
  end

  def report
    @mindlog = Mindlog.find(params[:id])
    authorize! :report , @mindlog
    if params[:flag]
      @report = @mindlog.reports.new
      @report.user = current_user
      @report.flag_id = params[:flag]
      if @report.save
        flash[:success] = "Content successfully reported"
      else
        flash[:error] = "Content couldn't be reported"
      end

      respond_to do |format|
        format.html { redirect_to @mindlog and return}
        format.js #added
      end
    end
  end

  def reports
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

  def like
    @mindlog = Mindlog.find(params[:id])
    if can? :respond , @mindlog
      @mindlog.users << current_user unless @mindlog.users.include? current_user
      respond_to do |format|
        format.html { redirect_to :back }
        format.js #added
      end
    else
      respond_to do |format|
        format.html { redirect_to @mindlog , error:"Guests cannot Interact" }
        format.js {render partial: 'shared/no_interact.js.erb'}
      end
    end
  end

    def unlike
    @mindlog = Mindlog.find(params[:id])
    if can? :respond , @mindlog
      @mindlog.users.destroy(current_user)
      respond_to do |format|
        format.html { redirect_to :back }
        format.js #added
      end
    else
      respond_to do |format|
        format.html { redirect_to @mindlog , error:"Guests cannot Interact" }
        format.js {render partial: 'shared/no_interact.js.erb'}
      end
    end
  end

def moderation_queue
  @mindlogs = Mindlog.queued
end

  # Regex ensures strings starting with '#' are ignored
  def autocomplete
      unless /\A#.+/.match(params[:query])
        @mindlogs = Mindlog.search(params[:query], where:{workflow_state:"published"},fields: [:title,{title: :text_start}], limit: 10).as_json(only:[:title]) 
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
    return false if params[:q].size < 3
    @tags = ActsAsTaggableOn::Tag.where("tags.name LIKE ?", "%#{params[:q]}%") 
    respond_to do |format|
      format.json { render :json => @tags.map{|t| {:id => t.name, :name => t.name }}}
    end
  end

end
