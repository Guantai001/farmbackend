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

ActiveRecord::Schema[7.0].define(version: 2023_05_22_063816) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cows", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.string "breed"
    t.string "health"
    t.bigint "admin_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_cows_on_admin_id"
  end

  create_table "dairy_costs", force: :cascade do |t|
    t.string "date"
    t.integer "price"
    t.string "item"
    t.bigint "admin_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_dairy_costs_on_admin_id"
  end

  create_table "dairy_sells", force: :cascade do |t|
    t.string "date"
    t.integer "price"
    t.string "item"
    t.bigint "admin_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_dairy_sells_on_admin_id"
  end

  create_table "milk_prices", force: :cascade do |t|
    t.integer "price"
    t.bigint "admin_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_milk_prices_on_admin_id"
  end

  create_table "milks", force: :cascade do |t|
    t.string "date"
    t.integer "amount"
    t.bigint "cow_id", null: false
    t.bigint "admin_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_milks_on_admin_id"
    t.index ["cow_id"], name: "index_milks_on_cow_id"
  end

  create_table "tea_picks", force: :cascade do |t|
    t.integer "kilo"
    t.integer "price"
    t.string "date"
    t.bigint "tea_id", null: false
    t.bigint "admin_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_tea_picks_on_admin_id"
    t.index ["tea_id"], name: "index_tea_picks_on_tea_id"
  end

  create_table "tea_prices", force: :cascade do |t|
    t.integer "price"
    t.bigint "admin_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_tea_prices_on_admin_id"
  end

  create_table "teas", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.integer "size"
    t.bigint "admin_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_teas_on_admin_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cows", "admins"
  add_foreign_key "dairy_costs", "admins"
  add_foreign_key "dairy_sells", "admins"
  add_foreign_key "milk_prices", "admins"
  add_foreign_key "milks", "admins"
  add_foreign_key "milks", "cows"
  add_foreign_key "tea_picks", "admins"
  add_foreign_key "tea_picks", "teas"
  add_foreign_key "tea_prices", "admins"
  add_foreign_key "teas", "admins"
end
