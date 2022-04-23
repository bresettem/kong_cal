class ChangeIndexInAlphaCoin < ActiveRecord::Migration[7.0]
  def change
    remove_index :alpha_coins, :symbol
    remove_index :alpha_coins, :name
    remove_index :alpha_coins, :user_id
    remove_column :alpha_coins, :user_id
  end
end