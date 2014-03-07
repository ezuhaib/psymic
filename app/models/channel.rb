class Channel < ActiveRecord::Base
attr_accessible :body, :slug, :query, :title, :cover
extend FriendlyId
friendly_id :title , use: :slugged

has_attached_file :cover, styles:{standard: "730x200"}
crop_attached_file :cover , aspect: '730:200' , min_size:'730x200'

##############################################
# VALIDATIONS
###############################################
validates_presence_of :query
validates_size_of :body , in: 140...1000
validates_attachment_content_type :cover, :content_type => /\Aimage\/.*\Z/
validates_attachment_size :cover, in: 0..5000.kilobytes
validates :cover, :dimensions => { :width => 730, :height => 200 }

##############################################
# QUERY
# Using serialized queries so that complex
# queries may easily be incorporated in future
###############################################
serialize :query
Query = [:all_of_these]

def self.query_attr_accessor()
  Query.each do |method_name|
    eval "
      def #{method_name}
        (self.query||{})[:#{method_name}]
      end
      def #{method_name}=(value)
        self.query ||= {}
        self.query[:#{method_name}] = value
      end
      attr_accessible :#{method_name}
    "
  end
end

query_attr_accessor
end
