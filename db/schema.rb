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

ActiveRecord::Schema.define(version: 20150805233257) do

  create_table "proxy_rules", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "domain"
    t.string   "name"
    t.string   "url"
    t.integer  "auth_type"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.datetime "expired_at"
    t.boolean  "https",      default: false, null: false
  end

  add_index "proxy_rules", ["expired_at"], name: "index_proxy_rules_on_expired_at"
  add_index "proxy_rules", ["user_id"], name: "index_proxy_rules_on_user_id"

  create_table "slack_credentials", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "slack_user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "slack_credentials", ["user_id"], name: "index_slack_credentials_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "nickname"
    t.string   "email"
    t.string   "icon_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
