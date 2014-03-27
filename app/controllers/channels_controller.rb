class ChannelsController < ApplicationController
  # GET /channels
  # GET /channels.json

  before_filter :fetch_channel , only:[:show,:edit,:update,:destroy,:crop,:mindlogs]

  def fetch_channel
    @channel = Channel.find_by_slug(params[:id]) || not_found
  end

  def index
    @channels = Channel.all
    @page_title = "Channels"
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
    @mindlogs = Mindlog.search @channel.all_of_these, where:{workflow_state:"published"},
                  fields: [:tags_name], limit:5, facets: {tags_name: {limit:10}}
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
    @mindlogs = Mindlog.search @channel.all_of_these, where:{workflow_state:"published"}, fields: [:tags_name], page: params[:page], per_page:1,
                  facets: {tags_name: {limit:10}}
  end

end
