class CommentsController < ApplicationController

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
    authorize! :update , Comment

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @commentable = Comment.get_commentable(params[:type],params[:id])
    @comments = @commentable.comments.all
    authorize! :read , @commentable => Comment
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
      format.js #added
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = Comment.new
    authorize! :create , @commentable => Comment
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
    authorize! :update , @commentable => Comment
  end

  # POST /comments
  # POST /comments.json
  def create
    authorize! :create , @commentable => Comment
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @mentions = extract_mentions( @comment.body )
    respond_to do |format|
      if @comment.save
        @comment.create_activity :create_on_response , recipient: @comment.commentable.user , owner: current_user unless @comment.commentable.user == current_user
        @comment.notify_mentions(@mentions) if @mentions
        format.html { redirect_to :back, notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
        format.js #added
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])
    authorize! :update, @commentable => Comment
    respond_to do |format|
      if @comment.update_attributes(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    authorize! :destroy , @commentable => Comment
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
      format.js #added
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type, :user_id)
  end
end
