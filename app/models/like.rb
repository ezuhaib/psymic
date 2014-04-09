  class Like < ActiveRecord::Base
  attr_accessible :user_id
  belongs_to :likeable, polymorphic:true , counter_cache:true
  belongs_to :user

  end