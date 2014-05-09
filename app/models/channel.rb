class Channel < ActiveRecord::Base
extend FriendlyId
friendly_id :title , use: :slugged

has_attached_file :cover, styles:{standard: "730x200#"}
has_attached_file :icon,  styles:{large: "128x128#", standard: "48x48#" , mini: "20x20#"},
                          default_url: "paperclip_defaults/channels/icons/:style/default.png"
crop_attached_file :cover , aspect: '730:200' , min_size:'730x200'

##############################################
# RELATIONSHIPS
##############################################
has_many :items , class_name: "ChannelItem"
has_many :mindlogs , ->{where 'channel_items.status = ?','approved'} , through: :items , source: :item , source_type: 'Mindlog'

##############################################
# VALIDATIONS
##############################################
validates_size_of :body , in: 140...1000
validates_attachment_content_type :cover, :content_type => /\Aimage\/.*\Z/
validates_attachment_size :cover, in: 0..5000.kilobytes
validates :cover, :dimensions => { :width => 730, :height => 200 }
validates_attachment_content_type :icon, :content_type => /\Aimage\/.*\Z/
validates_attachment_size :icon, in: 0..1500.kilobytes
validates :cover, :dimensions => { :width => 128, :height => 128 }

end
