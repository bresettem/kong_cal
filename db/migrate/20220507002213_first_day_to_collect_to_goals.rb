class FirstDayToCollectToGoals < ActiveRecord::Migration[7.0]
  def up
    add_column :goals, :first_day_to_collect, :date, default: Date.today, null: false
  end

  def down
    remove_column :goals, :first_day_to_collect
  end
end