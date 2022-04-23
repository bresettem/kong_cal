class AddUserIdToTables < ActiveRecord::Migration[7.0]
  def up
    add_column :alpha_coins, :user_id, :integer, null: false
    add_column :tribe_items, :user_id, :integer, null: false
    add_column :claims, :user_id, :integer, null: false
    add_column :goals, :user_id, :integer, null: false

    add_index :alpha_coins, :user_id
    add_index :tribe_items, :user_id
    add_index :claims, :user_id
    add_index :goals, :user_id
  end

  def down
    remove_column :alpha_coins, :user_id, null: false
    remove_column :tribe_items, :user_id, null: false
    remove_column :claims, :user_id, null: false
    remove_column :goals, :user_id, null: false

    remove_index :alpha_coins, :user_id
    remove_index :tribe_items, :user_id
    remove_index :claims, :user_id
    remove_index :goals, :user_id
  end
end