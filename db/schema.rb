# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110119152522) do

  create_table "groupings", :force => true do |t|
    t.integer  "group_id"
    t.integer  "player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "autoinvite"
    t.boolean  "autoaccept"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "autocreate_matches"
    t.integer  "solicit1_ndays"
    t.integer  "solicit2_ndays"
  end

  create_table "invitations", :force => true do |t|
    t.integer  "match_id"
    t.integer  "player_id"
    t.string   "acceptance_code"
    t.string   "refusal_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.datetime "accepted_at"
    t.datetime "rejected_at"
    t.integer  "number_of_sent_mails",   :default => 0, :null => false
    t.integer  "num_additional_players", :default => 0, :null => false
  end

  create_table "locations", :force => true do |t|
    t.string   "address"
    t.string   "google_link"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matches", :force => true do |t|
    t.date     "date"
    t.time     "time"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",      :default => "open", :null => false
    t.integer  "group_id"
  end

  create_table "players", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.string   "phone"
    t.string   "birth_date"
    t.string   "birth_place"
  end

  create_table "role_attributions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
  end

end
