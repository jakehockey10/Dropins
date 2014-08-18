# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140818054322) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendances", force: true do |t|
    t.integer  "user_id"
    t.integer  "dropin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "commitments", force: true do |t|
    t.integer  "user_id"
    t.integer  "dropin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commitments", ["dropin_id"], name: "index_commitments_on_dropin_id", using: :btree
  add_index "commitments", ["user_id", "dropin_id"], name: "index_commitments_on_user_id_and_dropin_id", unique: true, using: :btree
  add_index "commitments", ["user_id"], name: "index_commitments_on_user_id", using: :btree

  create_table "dropins", force: true do |t|
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "price",      precision: 8, scale: 2
    t.integer  "rink_id"
    t.integer  "user_id"
    t.integer  "limit"
  end

  add_index "dropins", ["rink_id"], name: "index_dropins_on_rink_id", using: :btree

  create_table "gmail_contacts", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "profile_picture"
    t.string   "phone_number"
  end

  add_index "gmail_contacts", ["user_id"], name: "index_gmail_contacts_on_user_id", using: :btree

  create_table "microposts", force: true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "microposts", ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at", using: :btree

  create_table "relationships", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "rinks", force: true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",                  default: false
    t.integer  "state"
    t.string   "email_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "wepay_access_token"
    t.integer  "wepay_account_id"
    t.string   "first_name"
    t.string   "second_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
