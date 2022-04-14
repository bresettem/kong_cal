class CreateTribeItems < ActiveRecord::Migration[7.0]
  def change
    create_table :tribe_items do |t|
      t.string :item, null: false
      t.float :daily_yield, default: 0
      t.integer :price, default: 0
      t.integer :owned, default: 0

      t.timestamps
    end
  end
end