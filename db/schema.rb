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

ActiveRecord::Schema[7.0].define(version: 2022_04_23_040926) do
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
  end

  create_table "claims", force: :cascade do |t|
    t.date "claimed", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_claims_on_user_id"
  end

  create_table "goals", force: :cascade do |t|
    t.float "unclaimed_coins", default: 0.0, null: false
    t.float "goal", default: 0.0, null: false
    t.date "started_on", default: "2022-04-22", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "tribe_items", force: :cascade do |t|
    t.string "item", null: false
    t.float "daily_yield", default: 0.0
    t.integer "price", default: 0
    t.integer "owned", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id", "item"], name: "index_tribe_items_on_user_id_and_item"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
