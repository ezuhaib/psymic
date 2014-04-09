class Response < ActiveRecord::Base

  include PublicActivity::Common

	belongs_to :mindlog
  attr_accessible :body, :mindlog_id , :user_id , :rating, :nature
  has_many :votes
  has_many :users , :through=> :votes
  has_many :comments , :as=> :commentable , :dependent=> :destroy
  belongs_to :user

  after_save :dispatcher
  validates_presence_of :body , :mindlog_id , :user_id , :nature

  def dispatcher()
    # Notify Subscribers
    self.mindlog.subscriptions.each do |s|
      s.counter || s.counter = 0
      s.counter += 1
      s.save
    end
  end

  def notify_mentions(mentions)
    mentions.each do |m|
      self.create_activity :mention , recipient: User.find(m) , owner: self.user
    end
  end

end
