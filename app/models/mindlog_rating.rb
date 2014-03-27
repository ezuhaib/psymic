class MindlogRating < ActiveRecord::Base
  attr_accessible :mindlog_id, :rating, :user_id
  belongs_to :mindlog
  belongs_to :user
  validates_uniqueness_of :user_id
	after_save :cache_rating_percent

	def cache_rating_percent
		self.mindlog.update_column(:rating_percent, self.mindlog.calc_rating_percent)
	end
end
