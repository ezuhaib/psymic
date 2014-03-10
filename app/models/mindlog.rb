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
scope :published, where(workflow_state: "published")
scope :queued, -> { where(workflow_state: ["unpublished","awaiting_review"]) }

#############################
# ATTRIBUTES
#############################
attr_accessible :description, :title , :topic_list , :status, :workflow_state, :review
attr_accessor :review

#############################
# VALIDATIONS
#############################
validates :title , :presence => 'true' , :length=> {:in=>10..50}
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

end
