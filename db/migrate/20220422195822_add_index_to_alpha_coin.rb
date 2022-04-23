class AddIndexToAlphaCoin < ActiveRecord::Migration[7.0]
  def up
    add_index :alpha_coins, :symbol, unique: :true
  end

  def down
    remove_index :alpha_coins, :symbol
  end
end