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

ActiveRecord::Schema.define(version: 20150914034537) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "nominations", force: :cascade do |t|
    t.integer  "nominee_membership_id", null: false
    t.integer  "nominator_id",          null: false
    t.string   "body",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "nominations", ["nominator_id"], name: "index_nominations_on_nominator_id", using: :btree
  add_index "nominations", ["nominee_membership_id"], name: "index_nominations_on_nominee_membership_id", using: :btree

  create_table "team_memberships", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "team_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "team_memberships", ["team_id"], name: "index_team_memberships_on_team_id", using: :btree
  add_index "team_memberships", ["user_id", "team_id"], name: "index_team_memberships_on_user_id_and_team_id", unique: true, using: :btree
  add_index "team_memberships", ["user_id"], name: "index_team_memberships_on_user_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name",                       null: false
    t.boolean  "enrolling",  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["name"], name: "index_teams_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.integer  "sign_in_count",      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "provider",                           null: false
    t.string   "uid",                                null: false
    t.string   "name"
    t.string   "image"
    t.boolean  "admin",              default: false, null: false
  end

  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true, using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "nomination_id", null: false
    t.integer  "voter_id",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["nomination_id", "voter_id"], name: "index_votes_on_nomination_id_and_voter_id", unique: true, using: :btree
  add_index "votes", ["nomination_id"], name: "index_votes_on_nomination_id", using: :btree
  add_index "votes", ["voter_id"], name: "index_votes_on_voter_id", using: :btree

end
