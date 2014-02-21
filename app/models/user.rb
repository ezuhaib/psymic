class User < ActiveRecord::Base

################################
# ATTRIBUTES
################################
attr_accessible :username, :email, :password, :password_confirmation, :remember_me , :gender , :dob , :body , :country, :login,:testing_key #temporary... restricts signups
attr_accessor :login,:testing_key #temporary... restricts signups

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
has_many :mindlogs, :through => :likes, :source => :likeable, :source_type => 'Mindlog'

################################
# INTEGRATIONS
################################
devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
acts_as_reader

def self.find_first_by_auth_conditions(warden_conditions)
  conditions = warden_conditions.dup
  if login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
  else
    where(conditions).first
  end
end

################################
# VALIDATIONS
################################

validates :username, :uniqueness => {:case_sensitive => false}
validates_presence_of :username , :gender , :dob , :country
validates_size_of :body , in: 40...1000

################################
# CALLBACKS
################################

# Override Devise::Confirmable#after_confirmation
def after_confirmation
UserMailer.registration_confirmation(self).deliver
end

################################
# INSTANCE METHODS
################################
def role?(role)
  self.roles.pluck(:title).include?(role.to_s)
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
