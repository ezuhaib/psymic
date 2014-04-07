class Comic < ActiveRecord::Base
  attr_accessible :caption, :likes_count, :mindlog_id, :user_id, :comic, :published
  has_attached_file :comic, :styles => { :standard => "700>" }
  belongs_to :user
  belongs_to :mindlog
  has_many :likes , as: :likeable

  # Validations
  validates_presence_of :caption, :user_id
  validates_attachment :comic , presence: true , size: {in: 0..6000.kilobytes} , content_type:{content_type: /\Aimage\/.*\Z/}
  validates :comic, :dimensions => { :width => 700, :height => 200 }

  def published
  	self.status == "published" ? 1 : 0
  end

  def published=(val)
    if val == '1'
      self.status = "published"
    else
      self.status = "unpublished" unless self.status == "unapproved"
    end

  end

end
