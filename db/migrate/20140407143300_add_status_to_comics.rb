class AddStatusToComics < ActiveRecord::Migration
  def change
    add_column :comics, :status, :string , default: "unapproved"
  end
end
