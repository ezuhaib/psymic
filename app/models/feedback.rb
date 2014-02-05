class Feedback < ActiveRecord::Base
	belongs_to :user
	has_many :comments , as: :commentable
  	attr_accessible :body, :nature, :user_id
  	validates_presence_of :body
  	scope :not_backstage, where('nature not in (?)',"backstage")
  	scope :backstage , where(nature:"backstage")

  def self.natures
  	@natures = {
  		'general'=>'general',
  		'issue report'=>'issue',
  		'suggestion'=>'suggestion'
  	}
  end

  validates_inclusion_of :nature, :in=> natures.map{|k,v| v}+["backstage"]

end
