# Update user points (karma) whenever there are changes
# in the given model

module Scorable
  extend ActiveSupport::Concern

  included do
    after_create :update
    after_update :update
    after_destroy :update
  end

  def update
  	self.user.update_points
  end

end