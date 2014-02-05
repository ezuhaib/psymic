class AddCounterToMlexplanations < ActiveRecord::Migration
  def change
    add_column :mlexplanations, :counter, :integer
  end
end
