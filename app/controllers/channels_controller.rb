class ChannelsController < ApplicationController
  # GET /channels
  # GET /channels.json

  before_filter :fetch_channel , only:[:show,:edit,:update,:destroy,:crop,:mindlogs,:queue,:item]

  def fetch_channel
    @channel = Channel.find_by_slug(params[:id]) || not_found
  end

  def index
    @channels = Channel.order(:title).all
    @page_title = "Psymic Channels"
    authorize! :read , Channel
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @channels }
    end
  end

  # GET /channels/1
  # GET /channels/1.json
  def show
    authorize! :read , Channel
    @page_title = "#{@channel.title} Channel"
    @mindlogs = @channel.mindlogs
    @queue_size = @channel.items.where(status:"pending").count
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @channel }
    end
  end

  # GET /channels/new
  # GET /channels/new.json
  def new
    authorize! :create , Channel
    @page_title = "New channel"
    @channel = Channel.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @channel }
    end
  end

  # GET /channels/1/edit
  def edit
    authorize! :update , Channel
    @page_title = "Edit Channel"
  end

  # POST /channels
  # POST /channels.json
  def create
    @channel = Channel.new(params[:channel])
    authorize! :create , Channel

      if params[:channel][:cover] && @channel.save
        redirect_to crop_cover_path(@channel)
      elsif @channel.save
        redirect_to @channel, notice: 'Channel was successfully created.'
      else
        render action: "new"
      end
  end

  # PUT /channels/1
  # PUT /channels/1.json
  def update
    authorize! :update , Channel
      if params[:channel][:cover] && @channel.update_attributes(params[:channel])
          redirect_to action: :crop
      elsif @channel.update_attributes(params[:channel])
          redirect_to @channel, notice: 'Channel was successfully updated.'
      else
        render action: "edit"
      end
  end

  def crop
    @page_title = "Edit Channel"
  end

  # DELETE /channels/1
  # DELETE /channels/1.json
  def destroy
    authorize! :destroy , Channel
    redirect_to channels_url, notice:"Channel removed successfully" if @channel.destroy
  end

  def mindlogs
    authorize! :read , Channel
    @page_title = "#{@channel.title} Channel > Mindlogs"
    @mindlogs = @channel.mindlogs.page(params[:page])
  end

  def queue
    authorize! :moderate , @channel
    if params[:show] and params[:show] == "rejected"
      @items = @channel.items.where(status:"rejected")
    else
      @items = @channel.items.where(status:"pending")
    end
  end

  def item
    authorize! :moderate , @channel
    @item = ChannelItem.find(params[:item])
    if params[:do] and params[:do] == "approve" and @item.channel == @channel
      @item.update_attribute(:status,:approved)
      @notice = "Successfully approved"
      @item.item.create_activity :channel_accept , recipient: User.find(@item.submitter_id) , owner: @channel unless @item.submitter_id == current_user.id
    elsif params[:do] and params[:do] == "reject" and @item.channel == @channel
      @item.update_attribute(:status,:rejected)
      @notice = "Successfully Rejected"
      @item.item.create_activity :channel_accept , recipient: User.find(@item.submitter_id) , owner: @channel unless @item.submitter_id == current_user.id
    end
    @path = request.env["HTTP_REFERER"] || queue_channel_path(@channel)
    redirect_to @path , notice: @notice
  end

  def autocomplete
    @channels = Channel.select([:id,:title]).where("lower(title) like ?","%#{params[:query].downcase}%")
    render json: @channels
  end

  def add_item
    current_user.role?(:admin) ? @status = "approved" : @status = "pending"#more granular permissions later
    ci = ChannelItem.new( channel_id:params[:channel_id],
                        item_type:params[:item_type],
                        item_id:params[:item_id],
                        submitter_id:current_user.id,
                        status:@status)
    if ci.save
      flash[:success] = "Suggested successfully. Awaiting Moderator's approval."
      flash[:success] = "Added to channel directly as administrator" if @status == "approved"
      redirect_to polymorphic_path(ci.item)
    else
      flash[:error] = "An error occured. Admin is notified."
      flash[:error] = ci.errors.full_messages.first
      redirect_to polymorphic_path(ci.item)+'/channels/add'
    end
  end

end
