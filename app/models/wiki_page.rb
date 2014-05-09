class WikiPage < ActiveRecord::Base
  validates_presence_of :body, :title, :user_id
  belongs_to :user
  before_save :manage_slug
  extend FriendlyId
  friendly_id :slug

  # Overriding friendly id's sluggin mechanism, using our own
  def manage_slug
  	self.slug = self.title.parameterize if self.slug.blank?
  end

end
