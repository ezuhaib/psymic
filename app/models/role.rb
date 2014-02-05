class Role < ActiveRecord::Base
  attr_accessible :title
  has_and_belongs_to_many :users
end
