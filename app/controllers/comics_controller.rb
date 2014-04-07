class ComicsController < ApplicationController
  # GET /comics
  # GET /comics.json
  def index
    @comics = Comic.where(status: "published").order("created_at DESC").page(params[:page]).per(15)
  end

  # GET /comics/1
  # GET /comics/1.json
  def show
    @comic = Comic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comic }
    end
  end

  # GET /comics/new
  # GET /comics/new.json
  def new
    @comic = Comic.new
    authorize! :create , Comic
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comic }
    end
  end

  # GET /comics/1/edit
  def edit
    @comic = Comic.find(params[:id])
    authorize! :update , @comic
  end

  # POST /comics
  # POST /comics.json
  def create
    authorize! :create , Comic
    @comic = Comic.new(params[:comic])
    @comic.user_id = current_user.id

    respond_to do |format|
      if @comic.save
        format.html { redirect_to @comic, notice: 'Comic was successfully created.' }
        format.json { render json: @comic, status: :created, location: @comic }
      else
        format.html { render action: "new" }
        format.json { render json: @comic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comics/1
  # PUT /comics/1.json
  def update
    @comic = Comic.find(params[:id])
    authorize! :update , @comic
    respond_to do |format|
      if @comic.update_attributes(params[:comic])
        format.html { redirect_to @comic, notice: 'Comic was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comics/1
  # DELETE /comics/1.json
  def destroy
    @comic = Comic.find(params[:id])
    @comic.destroy

    respond_to do |format|
      format.html { redirect_to comics_url }
      format.json { head :no_content }
    end
  end

  def like
    @comic = Comic.find(params[:id])
    if @comic.likes.exists?(user_id: current_user.id)
      @comic.likes.where(user_id: current_user).first.destroy
    else
      @comic.likes.create(user_id: current_user.id)
    end

    respond_to do |format|
      format.html {redirect_to @comic}
      format.js #added
    end
  end

end
