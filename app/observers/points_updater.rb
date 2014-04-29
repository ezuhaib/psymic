class PointsUpdater < ActiveRecord::Observer
observe :mindlog , :response , :comment

	def after_create(record)
	 record.user.update_points
	end

	# Need to recalculate in case
	# record got published/unpublished
	def after_update(record)
	 record.user.update_points
	end

	def after_destroy(record)
	 record.user.update_points
	end

end
