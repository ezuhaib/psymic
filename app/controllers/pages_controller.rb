class PagesController < ApplicationController

  def index
  end

	def show
		case params[:path]
			when 'introduction'	then render 'introduction'
			when 'get-helped' then render 'get-helped'
			when 'contribute'
				@offer = current_user.offer || Offer.new
				render 'contribute'
      when 'faqs' then render 'faqs'
			else raise ActionController::RoutingError.new('Not Found')
		end
	end

  def root
    if !current_user
      render "splash" , layout:false
    else
      @mindlogs = Mindlog.limit(6).all
    end
  end

  def offers
    @offer = current_user.offer || Offer.new
    @offer.user = current_user

    respond_to do |format|
      if @offer.update_attributes(params[:offer])
        format.html { redirect_to :back, notice: 'Admin was successfully notified.' }
        format.json { render json: @offer, status: :created, location: @offer }
      else
        format.html { redirect_to :back, error: 'Could not submit your contribution offer.' }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

end