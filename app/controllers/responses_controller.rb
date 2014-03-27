class ResponsesController < ApplicationController


	def new
		@mindlog = Mindlog.find_by_id(params[:mindlog_id])
		@response = @mindlog.responses.build
	end

	def create
		@response = Response.new(params[:response])
		@response.user = current_user
		@mentions = extract_mentions( @response.body )
		if @response.save
			@response.create_activity :create , recipient: @response.mindlog.user , owner: current_user unless @response.mindlog.user == current_user
			@response.notify_mentions(@mentions) if @mentions
		  respond_to do |format|
			format.html { redirect_to @response.mindlog}
			format.json { render json: @response, status: :created, location: @response }
			format.js #added
			end
		else
			flash[:notice] = "Could not submit response."
			redirect_to @response.mindlog
		end
	end

  def destroy
	@response = Response.find(params[:id])
  	@response.destroy
	respond_to do |format|
		format.html {redirect_to :controller=>'mindlogs' , :action=>'show' , :id=>@response.mindlog_id}
	  	format.json
		format.js #added
	end
  end

	def show
	@response = Response.find(params[:id])

	respond_to do |format|
		format.html {redirect_to mindlog_path(@response.mindlog,response:@response.id)}
		format.js
	end
	end

	def vote #todo add error messages
		@response = Response.find(params[:id])
		# if voted already, clicking either up or down would cancel the vote
		if cannot? :vote , @response
			respond_to do |format|
			format.html { redirect_to @response.mindlog }
			format.js {render partial: 'shared/no_interact.js.erb'}
			end
		else

		if params[:q] == "up"
			if @vote = @response.votes.find_by_user_id(current_user)
				@vote.destroy
			else
				@vote = @response.votes.new
				@vote.user = current_user
				@vote.value = 1
				@vote.save
			end

		elsif params[:q] == "down"
			if @vote = @response.votes.find_by_user_id(current_user)
				@vote.destroy
			else
				@vote = @response.votes.new
				@vote.user = current_user
				@vote.value = -1
				@vote.save
			end
		end

		respond_to do |format|
			format.html { redirect_to @response.mindlog }
			format.js #added
			end
		end
	end

  def edit
	@response = Response.find(params[:id])
	@remote = "false"
  end

	def update
		@response = Response.find(params[:id])
	  	if @response.update_attributes(params[:response])
	    	flash[:notice] = "Successfully updated example."
	    	redirect_to @response.mindlog
		end
	end
end
