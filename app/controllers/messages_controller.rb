class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.json
  def index
    #using subquery because we need to call order twice, once for selection and then for true sorting
    @page_title  = "Messages"
    @message_ids = Message.select("DISTINCT ON(pairing) id")
                       .where("? IN (sender_id, recipient_id)", current_user.id)
                       .order("pairing, id DESC")
    @messages = Message.where(id: @message_ids).order("id desc")
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @page_title  = "Messaging with #{params[:username]}"
    @user = User.find_by_username(params[:username])
    @messages = Message.where(pairing: [current_user.id, @user.id].sort.join(","))
                       .page(params[:page])
                       .per(5)
    @message = Message.new
    redirect_to user_messages_path(@user.username,page: @messages.total_pages) if !params[:page]
  end

  # GET /messages/new
  # GET /messages/new.json
  def new
    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(params[:message])
    @message.sender_id = current_user.id

    respond_to do |format|
      if @message.save
        format.html { redirect_to user_messages_path(uname(@message.recipient_id)), notice: 'Message was successfully created.' }
        format.json { render json: @message, status: :created, location: @message }
      else
        format.html { render action: "new" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.json
  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end
end
