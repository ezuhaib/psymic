class ChannelItem < ActiveRecord::Base
  belongs_to :channel
  belongs_to :item , polymorphic: true
  validates_uniqueness_of :channel_id , scope:[:item_type,:item_id] , message:"already added"
end
