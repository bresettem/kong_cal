class AddClaimOnDaysToGoals < ActiveRecord::Migration[7.0]
  def up
    add_column :goals, :num_days_to_collect, :integer, default: 0, null: false
  end

  def down
    remove_column :goals, :num_days_to_collect
  end
end