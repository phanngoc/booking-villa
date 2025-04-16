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

ActiveRecord::Schema[7.2].define(version: 2025_04_13_104210) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "amenities", force: :cascade do |t|
    t.string "name"
    t.string "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "require_value", default: false
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

  create_table "chat_threads", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "status", default: "active"
    t.string "title"
    t.boolean "is_unread", default: true
    t.datetime "last_activity_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_chat_threads_on_status"
    t.index ["user_id"], name: "index_chat_threads_on_user_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "name"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_members_on_email", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "chat_thread_id", null: false
    t.text "content", null: false
    t.string "sender", null: false
    t.boolean "is_read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_thread_id"], name: "index_messages_on_chat_thread_id"
    t.index ["sender"], name: "index_messages_on_sender"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "content"
    t.boolean "is_read", default: false
    t.string "category"
    t.datetime "timestamp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reference_type"
    t.bigint "reference_id"
    t.index ["is_read"], name: "index_notifications_on_is_read"
    t.index ["reference_type", "reference_id"], name: "index_notifications_on_reference"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "icon"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_payment_methods_on_name", unique: true
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "booking_id", null: false
    t.decimal "amount"
    t.integer "status"
    t.string "transaction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "sol_amount"
    t.string "payment_address"
    t.bigint "payment_method_id"
    t.index ["booking_id"], name: "index_payments_on_booking_id"
    t.index ["payment_method_id"], name: "index_payments_on_payment_method_id"
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
    t.string "provider"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "villa_amenities", force: :cascade do |t|
    t.bigint "villa_id", null: false
    t.bigint "amenity_id", null: false
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["amenity_id"], name: "index_villa_amenities_on_amenity_id"
    t.index ["value"], name: "index_villa_amenities_on_value"
    t.index ["villa_id", "amenity_id"], name: "index_villa_amenities_on_villa_id_and_amenity_id", unique: true
    t.index ["villa_id"], name: "index_villa_amenities_on_villa_id"
  end

  create_table "villa_metafields", force: :cascade do |t|
    t.bigint "villa_id", null: false
    t.string "namespace", null: false
    t.string "key", null: false
    t.string "value_type", default: "string"
    t.text "value"
    t.boolean "visible_on_frontend", default: true
    t.integer "position", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["namespace", "key"], name: "index_villa_metafields_on_namespace_and_key"
    t.index ["villa_id", "namespace", "key"], name: "index_villa_metafields_on_villa_id_and_namespace_and_key", unique: true
    t.index ["villa_id"], name: "index_villa_metafields_on_villa_id"
  end

  create_table "villas", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.decimal "price"
    t.jsonb "amenities"
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
  add_foreign_key "chat_threads", "users"
  add_foreign_key "messages", "chat_threads"
  add_foreign_key "notifications", "users"
  add_foreign_key "payments", "bookings"
  add_foreign_key "payments", "payment_methods"
  add_foreign_key "reviews", "bookings"
  add_foreign_key "reviews", "users"
  add_foreign_key "reviews", "villas"
  add_foreign_key "villa_amenities", "amenities"
  add_foreign_key "villa_amenities", "villas"
  add_foreign_key "villa_metafields", "villas"
end
