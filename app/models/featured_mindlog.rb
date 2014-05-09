class FeaturedMindlog < ActiveRecord::Base
  validates_uniqueness_of :mindlog_id
end
