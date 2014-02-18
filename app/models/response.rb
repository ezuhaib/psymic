class Response < ActiveRecord::Base

  include Wire

	belongs_to :mindlog
  attr_accessible :body, :mindlog_id , :user_id , :rating, :nature
  #has_and_belongs_to_many :users , :uniq=> true
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

    # Notify Mindlog Author
    target = self.mindlog.user_id
    txt = "New response to {{ '#{self.mindlog.title}' | link: 'mindlogs/#{self.mindlog.id}' }}"
    tag = 'new_response'
    scope = "mindlogs/#{self.mindlog_id}"
    alt = "{{count}} new responses to {{ '#{self.mindlog.title}' | link: 'mindlogs/#{self.mindlog.id}' }}"
 
    notify(target,txt,tag,scope,:alt=>alt)
    end
  end

end
