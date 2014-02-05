class Notification < ActiveRecord::Base
  attr_accessible :counter, :text, :user_id, :tag, :scope

end
