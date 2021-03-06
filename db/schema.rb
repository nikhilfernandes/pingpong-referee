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

ActiveRecord::Schema.define(version: 20150718054637) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "championships", force: true do |t|
    t.string  "title"
    t.integer "referee_id"
    t.string  "status"
    t.string  "winner"
    t.integer "number_of_players"
    t.string  "bye_player_identity"
  end

  create_table "games", force: true do |t|
    t.integer "championship_id"
    t.string  "player1_identity"
    t.string  "player2_identity"
    t.integer "order_of_player1"
    t.integer "order_of_player2"
    t.string  "status"
    t.integer "player1_score"
    t.integer "player2_score"
    t.integer "round"
    t.string  "winner"
  end

  create_table "players", force: true do |t|
    t.integer "championship_id"
    t.string  "identity"
    t.string  "auth_token"
    t.string  "name"
    t.integer "defence_length"
    t.string  "host"
    t.string  "port"
    t.string  "path"
  end

  create_table "referees", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "referees", ["email"], name: "index_referees_on_email", unique: true, using: :btree
  add_index "referees", ["reset_password_token"], name: "index_referees_on_reset_password_token", unique: true, using: :btree

  create_table "rounds", force: true do |t|
    t.integer "game_id"
    t.integer "number"
    t.string  "turn"
    t.integer "offensive_number"
    t.json    "defensive_array"
    t.string  "winner"
    t.string  "last_played_by"
  end

end
