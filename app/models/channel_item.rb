class ChannelItem < ActiveRecord::Base
  attr_accessible :channel_id, :item_id, :item_type, :status, :submitter_id
  belongs_to :channel
  belongs_to :item , polymorphic: true
  validates_uniqueness_of :channel_id , scope:[:item_type,:item_id] , message:"already added"
end
