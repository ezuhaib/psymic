class User < ActiveRecord::Base

################################
# ATTRIBUTES
################################
attr_accessible :username, :email, :password, :password_confirmation, :remember_me , :gender , :dob , :body , :country, :login,:avatar, :points
attr_accessor :login,:testing_key

################################
# RELATIONS
################################
has_many :mindlogs
has_many :responses
has_many :comments
has_many :subscriptions
has_many :feedbacks
has_many :wiki_pages
has_and_belongs_to_many :roles
has_many :likes, :dependent => :destroy

################################
# FUNCTIONS: LOCAL
################################

# Add logic for male/female avatar or random avatars below
def self.set_default_avatar
  "avatars/:style/avatar_default.png"
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
  self.update_attributes(points: self.points_computed)
end

################################
# INTEGRATIONS
################################
devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
acts_as_reader
acts_as_readable :on => :created_at
extend FriendlyId
friendly_id :username
has_attached_file :avatar,
  :styles => { :thumb => "130x130#", :mini => "60x60#" },
  :default_url => set_default_avatar
crop_attached_file :avatar , min_size: "300x300"

################################
# VALIDATIONS
################################

validates :username, :uniqueness => {:case_sensitive => false}
validates_presence_of :username , :gender , :dob , :country
validates_size_of :body , in: 40...1000
validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
validates_attachment_size :avatar, in: 0..2000.kilobytes
validates :avatar, :dimensions => { :width => 300, :height => 300 }

################################
# CALLBACKS
################################

# Override Devise::Confirmable#after_confirmation
def after_confirmation
UserMailer.registration_confirmation(self).deliver
end

################################
# OPTIONS
################################
serialize :options
Options = {
  email_on_new_response:true ,
  email_on_response_comment:true
}

def self.options_attr_accessor()
  Options.keys.each do |method_name|
    eval "
      def #{method_name}
        self.options ||= {}
        self.options[:#{method_name}] || Options[:#{method_name}]
      end
      def #{method_name}=(value)
        self.options ||= {}
        self.options[:#{method_name}] = value
      end
      attr_accessible :#{method_name}
    "
  end
end

options_attr_accessor
end
