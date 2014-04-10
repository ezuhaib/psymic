class WikiPagesController < ApplicationController
  # GET /wiki_pages
  # GET /wiki_pages.json
  before_filter :fetch_wiki_page , only: [:show,:edit,:update,:destroy]
  def fetch_wiki_page
    @wiki_page = WikiPage.find_by_slug(params[:id])
  end

  # Index is itself a wiki page
  def index
    authorize! :read, WikiPage
    @wiki_page = WikiPage.find_by_slug(:root)
    render template: 'wiki_pages/show'
  end

  # GET /wiki_pages/1
  # GET /wiki_pages/1.json
  def show
    @wiki_title = params[:id]
    authorize! :read , WikiPage
    if @wiki_page.blank?
      @page_title = "Wiki page not found"
      render template:"wiki_pages/new_landing"
    else
      @page_title = @wiki_page.title
    end
  end

  # GET /wiki_pages/new
  # GET /wiki_pages/new.json
  def new
    authorize! :create , WikiPage
    @page_title = "New wiki page"
    @wiki_page = WikiPage.new
    @wiki_page.slug = params[:slug] if params[:slug]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @wiki_page }
    end
  end

  # GET /wiki_pages/1/edit
  def edit
  authorize! :update , WikiPage
  @page_title = "Editing wiki page"
  end

  # POST /wiki_pages
  # POST /wiki_pages.json
  def create
    authorize! :create , WikiPage
    @wiki_page = WikiPage.new(params[:wiki_page])
    @wiki_page.user_id = current_user.id

    respond_to do |format|
      if @wiki_page.save
        format.html { redirect_to @wiki_page, notice: 'Wiki page was successfully created.' }
        format.json { render json: @wiki_page, status: :created, location: @wiki_page }
      else
        format.html { render action: "new" }
        format.json { render json: @wiki_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /wiki_pages/1
  # PUT /wiki_pages/1.json
  def update
    authorize! :update , WikiPage
    respond_to do |format|
      if @wiki_page.update_attributes(params[:wiki_page])
        format.html { redirect_to @wiki_page, notice: 'Wiki page was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @wiki_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wiki_pages/1
  # DELETE /wiki_pages/1.json
  def destroy
    @wiki_page.destroy
    authorize! :destroy , @wiki_page

    respond_to do |format|
      format.html { redirect_to wiki_pages_url }
      format.json { head :no_content }
    end
  end
end
