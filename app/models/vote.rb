class Vote < ActiveRecord::Base
	
belongs_to :user
belongs_to :response
validates_presence_of :user_id
after_save :update_response
after_destroy :update_response

def update_response()
	@response = self.response
	@response.rating = Vote.where(response_id:self.response_id).pluck(:value).sum
	@response.save
end

end