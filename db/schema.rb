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

ActiveRecord::Schema[7.2].define(version: 2025_03_30_060007) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "amenities", force: :cascade do |t|
    t.string "name"
    t.string "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "villa_id", null: false
    t.date "check_in"
    t.date "check_out"
    t.decimal "total_price"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_bookings_on_user_id"
    t.index ["villa_id"], name: "index_bookings_on_villa_id"
  end

  create_table "filter_fields", force: :cascade do |t|
    t.string "name"
    t.string "field_type"
    t.text "options"
    t.boolean "active"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "key_query"
    t.string "column_name", default: "", null: false
    t.index ["column_name"], name: "index_filter_fields_on_column_name"
    t.index ["key_query"], name: "index_filter_fields_on_key_query", unique: true
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "booking_id", null: false
    t.decimal "amount"
    t.string "payment_method"
    t.integer "status"
    t.string "transaction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_payments_on_booking_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "villa_id", null: false
    t.bigint "booking_id", null: false
    t.integer "rating"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_reviews_on_booking_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
    t.index ["villa_id"], name: "index_reviews_on_villa_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "villa_amenities", force: :cascade do |t|
    t.bigint "villa_id", null: false
    t.bigint "amenity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["amenity_id"], name: "index_villa_amenities_on_amenity_id"
    t.index ["villa_id"], name: "index_villa_amenities_on_villa_id"
  end

  create_table "villas", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.decimal "price"
    t.text "amenities"
    t.text "description"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rooms"
    t.integer "bathrooms"
    t.integer "max_guests"
    t.string "images"
  end

  add_foreign_key "bookings", "users"
  add_foreign_key "bookings", "villas"
  add_foreign_key "payments", "bookings"
  add_foreign_key "reviews", "bookings"
  add_foreign_key "reviews", "users"
  add_foreign_key "reviews", "villas"
  add_foreign_key "villa_amenities", "amenities"
  add_foreign_key "villa_amenities", "villas"
end
