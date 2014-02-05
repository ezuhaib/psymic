class AddLastCommenterToMlexplanations < ActiveRecord::Migration
  def change
    add_column :mlexplanations, :last_commenter, :integer
  end
end
