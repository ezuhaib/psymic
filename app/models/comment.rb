class Comment < ActiveRecord::Base
  belongs_to :commentable , :polymorphic => true
  belongs_to :user
  validates_presence_of :user_id , :body ,:commentable_id, :commentable_type
  include PublicActivity::Common
  include Scorable

# To enable comments for a model:
# 1. MODEL: has_many :comments , as: :commentable
# 2. VIEW: render template: "comments/show" , locals: {commentable:@commentable}
# 3. For custom view, copy code from above template into your view
# 4. AJAX LOADING: i) add a .comments-js container where you wish the comments to load.
# 					ii) wrap the container within another #commentable-id one
# 					iii) link_to '' , get_comments(@commentable)

def self.get_commentable(type, id)
  type.capitalize.constantize.find(id)
end

def notify_mentions(mentions)
	mentions.each do |m|
	  self.create_activity "mention_on_#{self.commentable_type.downcase}" , recipient: User.find(m) , owner: self.user
	end
end

end
