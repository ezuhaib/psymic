class Meta::FeedbacksController < ApplicationController

  # GET /feedbacks
  # GET /feedbacks.json
  def index
    @page_title = "Psymic Meta"
    authorize! :read , Feedback
    @feedbacks = Feedback.not_backstage.order("created_at DESC").page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feedbacks }
    end
  end

  # GET /feedbacks/1
  # GET /feedbacks/1.json
  def show
    @feedback = Feedback.find(params[:id])
    @page_title = "Single Feedback"
    authorize! :read , @feedback
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feedback }
    end
  end

  # GET /feedbacks/new
  # GET /feedbacks/new.json
  def new
    authorize! :create , Feedback
    @page_title = "New feedback"
    @feedback = Feedback.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feedback }
    end
  end

  # GET /feedbacks/1/edit
  def edit
    @feedback = Feedback.find(params[:id])
    @page_title = "Editing feedback"
    authorize! :update , @feedback
  end

  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @feedback = Feedback.new(params[:feedback])
    @feedback.user_id = current_user.id
    authorize! :backstage , @feedback if @feedback.nature == "backstage"
    respond_to do |format|
      if (can? :create , Feedback) && @feedback.save
        format.html {
          if @feedback.nature == "backstage"
            redirect_to admin_backstage_path, notice: 'Successfully posted to backstage.'
          else
            redirect_to meta_feedbacks_path, notice: 'Feedback was successfully created.'
          end
        }

        format.json { render json: @feedback, status: :created, location: @feedback }
      else
        format.html { redirect_to meta_feedbacks_path , alert: @feedback.errors.messages.first }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /feedbacks/1
  # PUT /feedbacks/1.json
  def update
    @feedback = Feedback.find(params[:id])
    authorize! :update , @feedback

    respond_to do |format|
      if @feedback.update_attributes(params[:feedback])
        format.html { redirect_to @feedback, notice: 'Feedback was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feedbacks/1
  # DELETE /feedbacks/1.json
  def destroy
    @feedback = Feedback.find(params[:id])
    authorize! :destroy , @feedback
    @feedback.destroy

    respond_to do |format|
      format.html { redirect_to meta_feedbacks_path , notice: "Successfully deleted" }
      format.json { head :no_content }
    end
  end
end
