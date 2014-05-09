class Message < ActiveRecord::Base
  before_save :set_pairing

  # Pairing is used for creating aggregated messgage inbox/outbox page
  def set_pairing
  	self.pairing = [recipient_id, sender_id].sort.join(",")
  end
end