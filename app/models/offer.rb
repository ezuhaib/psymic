class Offer < ActiveRecord::Base
  attr_accessible :body, :user_id
  acts_as_readable :on => :created_at
  belongs_to :user
  validates_presence_of :user_id , :body
  has_many :comments , as: :commentable
end
