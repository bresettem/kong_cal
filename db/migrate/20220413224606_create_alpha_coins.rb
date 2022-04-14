class CreateAlphaCoins < ActiveRecord::Migration[7.0]
  def change
    create_table :alpha_coins do |t|
      t.string :name, null: false
      t.string :symbol, null: false
      t.string :last_updated, null: false
      t.float :price, null: false
      t.float :volume_24h, null: false
      t.float :volume_24h_change_24h, null: false
      t.float :market_cap, null: false
      t.float :percent_change_15m, null: false
      t.float :percent_change_30m, null: false
      t.float :percent_change_1h, null: false
      t.float :percent_change_6h, null: false
      t.float :percent_change_12h, null: false
      t.float :percent_change_24h, null: false
      t.float :percent_change_7d, null: false
      t.float :percent_change_30d, null: false
      t.float :percent_change_1y, null: false
      t.float :ath_price, null: false
      t.string :ath_date, null: false
      t.float :percent_from_price_ath, null: false
      t.timestamps
    end
  end
end