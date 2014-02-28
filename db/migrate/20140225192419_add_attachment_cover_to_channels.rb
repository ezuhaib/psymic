class AddAttachmentCoverToChannels < ActiveRecord::Migration
  def self.up
    change_table :channels do |t|

      t.attachment :cover

    end
  end

  def self.down

    drop_attached_file :channels, :cover

  end
end
