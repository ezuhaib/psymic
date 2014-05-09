class ResponsesController < ApplicationController

	def new
		@mindlog = Mindlog.find_by_id(params[:mindlog_id])
		@page_title = "New Response"
		@response = @mindlog.responses.build
	end

	def create
		@response = Response.new(response_params)
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
			format.html {redirect_to @response.mindlog , notice: "Deleted Response successfully" }
		  	format.json
			format.js #added
		end
	end

	def show
		@response = Response.find(params[:id])
		redirect_to mindlog_path(@response.mindlog,response:@response.id)
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
		@page_title = "Edit Response"
		@remote = "false"
	end

	def update
		@response = Response.find(params[:id])
	  	if @response.update_attributes(response_params)
	    	flash[:notice] = "Successfully updated example."
	    	redirect_to @response.mindlog
		end
	end

	private
	def response_params
		params.require(:response).permit(:body, :mindlog_id , :user_id , :rating, :nature)
	end
end
