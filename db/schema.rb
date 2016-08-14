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

ActiveRecord::Schema.define(version: 20160814004328) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "teams", force: :cascade do |t|
    t.citext   "slack_team_id",      null: false
    t.string   "team_name",          null: false
    t.string   "access_token",       null: false
    t.string   "install_scope",      null: false
    t.string   "installing_user_id", null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["slack_team_id"], name: "index_teams_on_slack_team_id", unique: true, using: :btree
  end

  create_table "terms", force: :cascade do |t|
    t.integer  "team_id",     null: false
    t.citext   "name",        null: false
    t.text     "description", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["team_id", "name"], name: "index_terms_on_team_id_and_name", unique: true, using: :btree
  end

end
