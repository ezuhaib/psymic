class AddAttachmentComicToComics < ActiveRecord::Migration
  def self.up
    change_table :comics do |t|

      t.attachment :comic

    end
  end

  def self.down

    drop_attached_file :comics, :comic

  end
end
