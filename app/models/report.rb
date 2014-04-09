class Report < ActiveRecord::Base
  attr_accessible :flag_id, :reportable_id, :reportable_type, :user_id
  belongs_to :reportable , :polymorphic => true
  belongs_to :user
  validates_uniqueness_of :flag_id , :scope=> [:reportable_type,:reportable_id,:user_id]

end
