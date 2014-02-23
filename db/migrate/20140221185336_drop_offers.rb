class DropOffers < ActiveRecord::Migration
  def up
  	drop_table :offers
  end

  def down
  	raise ActiveRecord::IrreversibleMigration
  end
end
