class MessagesController < ApplicationController

  before_action :set_message, only: [:edit, :update, :destroy]

  def index
    #using subquery because we need to call order twice, once for selection and then for true sorting
    authorize! :read , Message
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


  def show
    authorize! :read , Message
    @page_title  = "Messaging with #{params[:username]}"
    @user = User.find_by_username(params[:username])
    @messages = Message.where(pairing: [current_user.id, @user.id].sort.join(","))
                       .order('created_at ASC')
                       .page(params[:page])
                       .per(20)
    @message = Message.new
    redirect_to user_messages_path(@user.username,page: @messages.total_pages) if !params[:page]
  end

  def new
    authorize! :create , Message
    @message = Message.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @message }
    end
  end

  def edit
    @message = Message.find(params[:id])
  end

  def create
    @message = Message.new(message_params)
    @message.sender_id = current_user.id

    respond_to do |format|
      if @message.save
        flash[:success] = 'Message Sent.'
        format.html { redirect_to user_messages_path(uname(@message.recipient_id)) }
        format.json { render json: @message, status: :created, location: @message }
      else
        format.html { render action: "new" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize! :update , Message
    @message = Message.find(params[:id])
    respond_to do |format|
      if @message.update_attributes(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @message = Message.find(params[:id])
    authorize :destroy , Message
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end

  private

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:body, :mailed, :read, :recipient_id, :sender_id)
  end
end
