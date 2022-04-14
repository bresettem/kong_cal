# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_04_13_224606) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alpha_coins", force: :cascade do |t|
    t.string "name", null: false
    t.string "symbol", null: false
    t.string "last_updated", null: false
    t.float "price", null: false
    t.float "volume_24h", null: false
    t.float "volume_24h_change_24h", null: false
    t.float "market_cap", null: false
    t.float "percent_change_15m", null: false
    t.float "percent_change_30m", null: false
    t.float "percent_change_1h", null: false
    t.float "percent_change_6h", null: false
    t.float "percent_change_12h", null: false
    t.float "percent_change_24h", null: false
    t.float "percent_change_7d", null: false
    t.float "percent_change_30d", null: false
    t.float "percent_change_1y", null: false
    t.float "ath_price", null: false
    t.string "ath_date", null: false
    t.float "percent_from_price_ath", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "symbol"], name: "index_alpha_coins_on_name_and_symbol", unique: true
    t.index ["name"], name: "index_alpha_coins_on_name", unique: true
  end

  create_table "tribe_items", force: :cascade do |t|
    t.string "item", null: false
    t.float "daily_yield", default: 0.0
    t.integer "price", default: 0
    t.integer "owned", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item"], name: "index_tribe_items_on_item", unique: true
  end

end
