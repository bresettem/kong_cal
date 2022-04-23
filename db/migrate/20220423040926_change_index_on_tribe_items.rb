class ChangeIndexOnTribeItems < ActiveRecord::Migration[7.0]
  def change
    remove_index :tribe_items, :item
    remove_index :tribe_items, :user_id
    add_index :tribe_items, [:user_id, :item]
  end
end