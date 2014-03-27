class Mindlog < ActiveRecord::Base

#############################
# RELATIONSHIPS
#############################
belongs_to :user
has_many :likes, :as => :likeable, :dependent => :destroy
has_many :users, :through => :likes
has_many :responses , :dependent => :destroy
has_many :reports , :as=> :reportable , :dependent=> :destroy
has_many :subscriptions , :as=> :subscribable , :dependent =>:destroy
has_many :mindlog_ratings, dependent: :destroy
scope :published, where(workflow_state: "published")
scope :queued, -> { where(workflow_state: ["unpublished","awaiting_review"]) }

#############################
# ATTRIBUTES
#############################
attr_accessible :description, :title , :topic_list , :status, :workflow_state, :review , :rating_percent
attr_accessor :review

#############################
# VALIDATIONS
#############################
validates :title , :presence => 'true' , :length=> {:in=>10..85}
validates :description , :presence => 'true' , :length=> {:minimum=> 40}
validates_presence_of :user_id

#############################
# WORKFLOW
#############################
def state(state_name)
	self.update_attributes!(workflow_state:state_name)
end

def state?(state_name)
	self.workflow_state == state_name.to_s
end
#############################
# SEARCHKICK INTEGRATION
#############################

searchkick text_start: [:title]

def search_data
	attributes.merge tags_name: self.topics.map(&:name)
end


#############################
# OTHER INTEGRATIONS
#############################
acts_as_taggable_on :topics
include PublicActivity::Common

#############################
# INSTANCE METHODS
#############################
def featured?
	FeaturedMindlog.find_by_mindlog_id(self.id).present?
end

def toggle_feature(user_id)
	if !self.featured?
		FeaturedMindlog.create(mindlog_id:self.id,moderator_id:user_id)
	else
		FeaturedMindlog.find_by_mindlog_id(self.id).destroy
	end
end

def reset_watch(user_id)
	s = self.subscriptions.find_by_user_id(user_id)
	s.update_attributes(counter:0) if s
end

def calc_rating_percent
	ratings = MindlogRating.where(mindlog_id: self.id).pluck(:rating)
	ratings_sum = ratings.inject(:+)
	ratings_mean = ratings.sum/ratings.count if ratings_sum
	rating_percent = ratings_mean * 25 if ratings_mean
	rating_percent || 0
end

def rated_by?(user)
	self.mindlog_ratings.find_by_user_id(user).present?
end

end
