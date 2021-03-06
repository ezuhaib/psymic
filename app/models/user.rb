class User < ActiveRecord::Base

################################
# ATTRIBUTES
################################
attr_accessor :login,:testing_key

################################
# RELATIONS
################################
has_many :mindlogs
has_many :comics
has_many :responses
has_many :comments
has_many :subscriptions
has_many :feedbacks
has_many :wiki_pages
has_and_belongs_to_many :roles
has_many :likes, dependent: :destroy
has_many :mindlog_ratings, dependent: :destroy

################################
# FUNCTIONS: LOCAL
################################

# Add logic for male/female avatar or random avatars below
def self.set_default_avatar
  "paperclip_defaults/users/avatars/:style/avatar_default.jpg"
end

def self.find_first_by_auth_conditions(warden_conditions)
  conditions = warden_conditions.dup
  if login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
  else
    where(conditions).first
  end
end

################################
# FUNCTIONS: INSTANCE METHODS
################################
def role?(role)
  self.roles.pluck(:title).include?(role.to_s)
end

def points_computed
  mindlog_karma = self.mindlogs.published.count * 2
  response_karma = self.responses.count * 1
  comment_karma = self.comments.count * 0.2
  karma = mindlog_karma + response_karma + comment_karma
end

def update_points
  self.update_attribute(:points, self.points_computed)
end

################################
# FUNCTIONS: CLASS METHODS
################################

# emails unread notifications to users
def self.send_notifications
  @user_ids = PublicActivity::Activity.where(read:false,mailed:false).pluck(:recipient_id).uniq
  @user_ids.each do |u|
    UserMailer.unread_notifications(u).deliver if User.find(u).email_unread_notifications
  end
end

def self.send_messages
  @user_ids = Message.where(read:nil,mailed:nil).pluck(:recipient_id).uniq
  @user_ids.each do |u|
    UserMailer.unread_messages(u).deliver if User.find(u).email_new_messages_count
  end
end

def self.profile_params
  return [:username, :email, :gender , :dob , :body , :country, :avatar]
end

def self.top(limit= 5)
  User.order('points desc').limit(limit)
end

################################
# INTEGRATIONS
################################
devise :database_authenticatable, :registerable, :confirmable, 
         :recoverable, :rememberable, :trackable, :validatable
acts_as_reader
acts_as_readable :on => :created_at
extend FriendlyId
include Optionable
friendly_id :username
has_attached_file :avatar,
  :styles => { :thumb => "130x130#", :mini => "60x60#" , :inline => "25x25#" },
  :default_url => set_default_avatar
crop_attached_file :avatar , min_size: "300x300"

################################
# VALIDATIONS
################################

validates :username, :uniqueness => {:case_sensitive => false}
validates_presence_of :username , :gender , :dob , :country
validates_size_of :body , in: 40...1000
validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
validates_attachment_size :avatar, in: 0..2000.kilobytes
validates :avatar, :dimensions => { :width => 300, :height => 300 }
validate :username_sanity

def username_sanity
  unless self.username.match(/\A[a-zA-Z0-9.]+\Z/)
    errors.add(:username, "No space or symbols allowed (except period)")
  end
end

################################
# CALLBACKS
################################

# Override Devise::Confirmable#after_confirmation
def after_confirmation
UserMailer.registration_confirmation(self).deliver
end

def before_create
  self.username = self.username.downcase
end

################################
# OPTIONS
################################

options email_unread_notifications:true ,
        email_site_updates:true,
        email_new_messages_count:true


end
