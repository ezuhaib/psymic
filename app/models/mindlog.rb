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

#############################
# ATTRIBUTES
#############################
attr_accessible :description, :title , :topic_list , :status

#############################
# VALIDATIONS
#############################
validates :title , :presence => 'true' , :length=> {:in=>10..50}
validates :description , :presence => 'true' , :length=> {:minimum=> 40}
validates_presence_of :user_id

#############################
# WORKFLOW
#############################
include Workflow

workflow do
	state :new do
	  event :publish, transitions_to: :published
	  event :submit_for_review, transitions_to: :awaiting_review
	end
	state :awaiting_review do
	  event :publish, transitions_to: :published
	end
	state :published do
	  event :unpublish, transitions_to: :unpublished
	end
	state :unpublished do
		event :publish, transitions_to: :published
	end
end
#############################
# SEARCHKICK INTEGRATION
#############################
searchkick text_start: [:title]

def search_data
	attributes.merge(tags_name: self.topics.map(&:name))
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
