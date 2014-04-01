class Message < ActiveRecord::Base
  attr_accessible :body, :mailed, :read, :recipient_id, :sender_id
  before_save :set_pairing

  # Pairing is used for creating aggregated messgage inbox/outbox page
  def set_pairing
  	self.pairing = [recipient_id, sender_id].sort.join(",")
  end
end