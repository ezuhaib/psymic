class Subscription < ActiveRecord::Base

	# Currently subscriptions are compiled based on a push model rather than a pull model because
	# this is more retrieval friendly.
  belongs_to :subscribable , :polymorphic => true
  belongs_to :user
  validates_uniqueness_of :user_id , :scope => [:subscribable_type,:subscribable_id]

end
