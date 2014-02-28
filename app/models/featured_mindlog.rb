class FeaturedMindlog < ActiveRecord::Base
  attr_accessible :mindlog_id, :moderator_id
  validates_uniqueness_of :mindlog_id
end
