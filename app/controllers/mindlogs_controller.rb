class MindlogsController < ApplicationController

  # GET /mindlogs
  # GET /mindlogs.json

  def index
    sleep 3
    authorize! :read , Mindlog
    if params[:query].present?
      @mindlogs = Mindlog.search(params[:query], page: params[:page], fields: [:title] , highlight:{tag: "<strong>"}, track: true)
      @has_details = true
    elsif params[:tag]
      @mindlogs = Mindlog.tagged_with(params[:tag])
    else
      @mindlogs = Mindlog.search("*", page: params[:page] , per:20)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mindlogs }
    end
  end

  # Regex ensures strings starting with '#' are ignored
  def autocomplete
      unless /\A#.+/.match(params[:query])
        @mindlogs = Mindlog.search(params[:query], fields: [:title,{title: :text_start}], limit: 10).as_json(only:[:title]) 
      end
    render json: @mindlogs
  end

  # Using Jbuilder, stripping leading #'s drom query strings
  def autocomplete_tags
    @tags = Mindlog.topic_counts.where('name LIKE ?',"#{params[:query].delete("#")}%")
  end

  # GET /mindlogs/1
  # GET /mindlogs/1.json
  def show
    @mindlog = Mindlog.find(params[:id])
    @mindlog.status ||= "None yet."
    authorize! :read , @mindlog
		@response = @mindlog.responses.new
    if params[:only] == "explanations"
      @responses = @mindlog.responses.where(nature:"explanation").order("rating DESC")
    elsif params[:only] == "solutions"
      @responses = @mindlog.responses.where(nature:"solution").order("rating DESC")
    elsif params[:only] == "critiques"
      @responses = @mindlog.responses.where(nature:"critique").order("rating DESC")
    elsif params[:only] == "stories"
      @responses = @mindlog.responses.where(nature:"story").order("rating DESC")
    else
	   @responses = @mindlog.responses.order("created_at DESC")
   end
   @responses = @responses.page(params[:page]).per(10)
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

    respond_to do |format|
      if @mindlog.save
        format.html { redirect_to @mindlog, notice: 'Mindlog was successfully created.' }
        format.json { render json: @mindlog, status: :created, location: @mindlog }
      else
        format.html { render action: "new" }
        format.json { render json: @mindlog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /mindlogs/1
  # PUT /mindlogs/1.json
  def update
    @mindlog = Mindlog.find(params[:id])
    authorize! :update , @mindlog
    respond_to do |format|
      if @mindlog.update_attributes(params[:mindlog])
        format.html { redirect_to @mindlog, notice: 'Mindlog was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mindlog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mindlogs/1
  # DELETE /mindlogs/1.json
  def destroy
    @mindlog = Mindlog.find(params[:id])
    @mindlog.destroy
    authorize! :destroy , @mindlog
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

      respond_to do |format|
        format.html #added
        format.js #added
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

  #1. Define the tags path
  #2. Searches ActsAsTaggable::Tag Model look for :name in the created table.
  #3. it finds the tags.json path and whats on my form.
  #4. it is detecting the attribute which is :name for your tags.

def tags 
  @tags = ActsAsTaggableOn::Tag.where("tags.name LIKE ?", "%#{params[:q]}%") 
  respond_to do |format|
    format.json { render :json => @tags.map{|t| {:id => t.name, :name => t.name }}}
  end
end


end
