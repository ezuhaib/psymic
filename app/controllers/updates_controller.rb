class UpdatesController < ApplicationController
  # GET /updates
  # GET /updates.json
  def index
    @updates = Update.all
    @page_title = "News & Updates"

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @updates }
    end
  end

  # GET /updates/1
  # GET /updates/1.json
  def show
    @update = Update.find(params[:id])
    @page_title = @update.title

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @update }
    end
  end

  # GET /updates/new
  # GET /updates/new.json
  def new
    authorize! :create , Update
    @update = Update.new
    @page_title = "New Update"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @update }
    end
  end

  # GET /updates/1/edit
  def edit
    @update = Update.find(params[:id])
    authorize! :destroy , @update
    @page_title = "Editing Update #{@update.title}"
  end

  # POST /updates
  # POST /updates.json
  def create
    authorize! :create , Update
    @update = Update.new(update_params)
    @update.user_id = current_user.id

    respond_to do |format|
      if params[:commit] == "Preview"
        format.html { render action: "new" }
        format.json { render json: @update.errors, status: :unprocessable_entity }
      elsif @update.save
        format.html { redirect_to @update, notice: 'Update was successfully created.' }
        format.json { render json: @update, status: :created, location: @update }
      end
    end
  end

  # PUT /updates/1
  # PUT /updates/1.json
  def update
    @update = Update.find(params[:id])

    authorize! :update , @update
    respond_to do |format|
      if @update.update_attributes(update_params)
        format.html { redirect_to @update, notice: 'Update was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @update.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /updates/1
  # DELETE /updates/1.json
  def destroy
    @update = Update.find(params[:id])
    authorize! :destroy , @update
    @update.destroy

    respond_to do |format|
      format.html { redirect_to updates_url }
      format.json { head :no_content }
    end
  end

  private
  def update_params
    params.require(:update).permit(:body, :title, :user_id)
  end
end
