# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_23_124937) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.bigint "tenant_id"
    t.bigint "property_id"
    t.integer "status", default: 0
    t.date "start_rent_at"
    t.date "end_rent_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "amount_for_period"
    t.integer "number_of_guests"
    t.index ["property_id"], name: "index_bookings_on_property_id"
    t.index ["tenant_id"], name: "index_bookings_on_tenant_id"
  end

  create_table "chats", force: :cascade do |t|
    t.bigint "booking_id"
    t.integer "tenant_unread_messages_count", default: 0
    t.integer "provider_unread_messages_count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "tenant_id"
    t.bigint "provider_id"
    t.index ["booking_id"], name: "index_chats_on_booking_id"
    t.index ["provider_id"], name: "index_chats_on_provider_id"
    t.index ["tenant_id"], name: "index_chats_on_tenant_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "chat_id"
    t.text "text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "payer_id"
    t.bigint "recipient_id"
    t.bigint "booking_id"
    t.string "service"
    t.string "info"
    t.integer "amount"
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["booking_id"], name: "index_payments_on_booking_id"
    t.index ["payer_id"], name: "index_payments_on_payer_id"
    t.index ["recipient_id"], name: "index_payments_on_recipient_id"
  end

  create_table "properties", force: :cascade do |t|
    t.bigint "provider_id"
    t.string "name"
    t.string "location"
    t.text "description"
    t.integer "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "guests_capacity"
    t.string "address"
    t.integer "rooms_count"
    t.index ["provider_id"], name: "index_properties_on_provider_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "reviewer_id"
    t.string "reviewable_type"
    t.bigint "reviewable_id"
    t.integer "rate"
    t.text "text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reviewable_type", "reviewable_id"], name: "index_reviews_on_reviewable_type_and_reviewable_id"
    t.index ["reviewer_id"], name: "index_reviews_on_reviewer_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "email"
    t.string "password_digest"
    t.integer "role", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
