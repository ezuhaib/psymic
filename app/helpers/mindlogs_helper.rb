module MindlogsHelper
	def active_if_rating(rating)
		@my_rating = @mindlog.mindlog_ratings.find_by_user_id(current_user.id).try(:rating) if current_user
		return "active" if @my_rating == rating
	end

	def active_if_filter(filter)
		params[:filter] ||= 'all'
		@current_filter = params[:filter]
		return "active" if @current_filter == filter
	end
end
