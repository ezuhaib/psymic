class AddSlugToWikiPages < ActiveRecord::Migration
  def change
    add_column :wiki_pages, :slug, :string
    add_index :wiki_pages, :slug, unique: true
  end
end

class AddReconfirmableToUsers < ActiveRecord::Migration
	def change
		add_column :users, :unconfirmed_email, :string
	end
end