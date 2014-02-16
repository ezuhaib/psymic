class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  
  has_many :mindlogs
  has_many :responses
  has_many :comments
  has_many :subscriptions
  has_many :feedbacks
  acts_as_reader
  has_one :offer
  has_and_belongs_to_many :roles
  has_many :likes, :dependent => :destroy
  has_many :mindlogs, :through => :likes, :source => :likeable, :source_type => 'Mindlog'

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me , :gender , :dob , :body , :country
  attr_accessor :login,:testing_key #temporary... restricts signups
  attr_accessible :login,:testing_key #temporary... restricts signups
  # attr_accessible :title, :body

      def self.find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions).first
      end
    end

    validates :username, :uniqueness => {:case_sensitive => false}
    validates_presence_of :username , :gender , :dob , :country
    validates_size_of :body , in: 80...1500
    validate :check_testing_key

    def role?(role)
      self.roles.pluck(:title).include?(role.to_s)
    end

    def check_testing_key
      unless ["ocipidi66"].include? testing_key
        errors.add(:testing_key, "must be the one provided by Admin")
      end
    end

end
