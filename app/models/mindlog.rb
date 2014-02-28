class Mindlog < ActiveRecord::Base

	acts_as_taggable_on :topics
	searchkick text_start: [:title]
	belongs_to :user
	has_many :likes, :as => :likeable, :dependent => :destroy
  has_many :users, :through => :likes 
	has_many :responses , :dependent => :destroy
	has_many :reports , :as=> :reportable , :dependent=> :destroy
	has_many :subscriptions , :as=> :subscribable , :dependent =>:destroy
  attr_accessible :description, :title , :topic_list , :status

	validates :title , :presence => 'true' , :length=> {:in=>10..50}
	validates :description , :presence => 'true' , :length=> {:minimum=> 40}
	validates_presence_of :user_id

	#Topic tags are being included to facilitate faceted browsing and searching through tags
	def search_data
		attributes.merge(tags_name: self.topics.map(&:name))
	end

end
