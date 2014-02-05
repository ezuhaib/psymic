class Report < ActiveRecord::Base
  attr_accessible :flag_id, :reportable_id, :reportable_type, :user_id
  belongs_to :reportable , :polymorphic => true
  belongs_to :user
  validates_uniqueness_of :flag_id , :scope=> :user_id
  after_save :update_counter

  def update_counter
  	reportable = self.reportable
  reportable.reports_counter ||= 0
  reportable.reports_counter += 1
  reportable.save
  end

end
