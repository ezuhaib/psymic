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

    # Email Mindlog Author
    if self.mindlog.user.email_on_new_response == true
      UserMailer.new_response_on_mindlog(self).deliver
    end

  end

end
