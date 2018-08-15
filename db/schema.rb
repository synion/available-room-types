# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180815122252) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "reservations", force: :cascade do |t|
    t.date "checkin_date"
    t.date "checkout_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations_rooms", id: false, force: :cascade do |t|
    t.bigint "room_id", null: false
    t.bigint "reservation_id", null: false
    t.index ["room_id", "reservation_id"], name: "index_reservations_rooms_on_room_id_and_reservation_id"
  end

  create_table "room_types", force: :cascade do |t|
    t.string "name"
    t.float "price"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "number"
    t.bigint "room_type_id"
    t.index ["room_type_id"], name: "index_rooms_on_room_type_id"
  end

  add_foreign_key "rooms", "room_types"
end
