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

ActiveRecord::Schema[7.0].define(version: 2023_07_30_114658) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "author"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "availabilities", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_availabilities_on_user_id"
  end

  create_table "branches", force: :cascade do |t|
    t.string "name"
    t.string "branch_iden"
    t.string "company_iden"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_branches_on_company_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "company_iden"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_opening_hours", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.integer "day_of_week", null: false
    t.time "open_time"
    t.time "close_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_company_opening_hours_on_company_id"
  end

  create_table "deliveries", force: :cascade do |t|
    t.datetime "dest_arrive"
    t.datetime "dest_leave"
    t.bigint "schedule_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "dest_lat", precision: 10, scale: 6
    t.decimal "dest_lon", precision: 10, scale: 6
    t.datetime "origin_leave"
    t.decimal "origin_lat", precision: 10, scale: 6
    t.decimal "origin_lon", precision: 10, scale: 6
    t.string "origin_address"
    t.string "dest_address"
    t.string "customer_contact"
    t.index ["schedule_id"], name: "index_deliveries_on_schedule_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.bigint "branch_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "user_only"
    t.boolean "branch_only"
    t.index ["branch_id"], name: "index_schedules_on_branch_id"
    t.index ["user_id"], name: "index_schedules_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.string "role"
    t.bigint "branch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["branch_id"], name: "index_users_on_branch_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "availabilities", "users"
  add_foreign_key "branches", "companies"
  add_foreign_key "company_opening_hours", "companies"
  add_foreign_key "deliveries", "schedules"
  add_foreign_key "schedules", "branches"
  add_foreign_key "schedules", "users"
  add_foreign_key "users", "branches"
end
