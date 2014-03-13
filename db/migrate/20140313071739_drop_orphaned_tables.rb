class DropOrphanedTables < ActiveRecord::Migration
  def up
  	drop_table :cargo_wiki_articles
  	drop_table :cargo_wiki_users
  	drop_table :searchjoy_searches
  	drop_table :stasus
  end

  def down
  	raise ActiveRecord::IrreversibleMigration
  end
end
