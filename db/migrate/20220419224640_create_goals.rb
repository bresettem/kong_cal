class CreateGoals < ActiveRecord::Migration[7.0]
  def change
    create_table :goals do |t|
      t.float :unclaimed_coins, default: 0, null: false
      t.float :goal, default: 0, null: false
      t.date :started_on, default: Time.new, null: false

      t.timestamps
    end
  end
end