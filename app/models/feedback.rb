class Feedback < ActiveRecord::Base
	belongs_to :user
	has_many :comments , as: :commentable
	validates_presence_of :body , :nature , :user_id
	scope :not_backstage, ->{where('nature not in (?)',"backstage")}
	scope :backstage , ->{where(nature:"backstage")}

  def self.natures
  	@natures = {
  		'general'=>'general',
  		'issue report'=>'issue',
  		'suggestion'=>'suggestion'
  	}
  end

  validates_inclusion_of :nature, :in=> natures.map{|k,v| v}+["backstage"]

end
