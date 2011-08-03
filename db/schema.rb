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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110803062812) do

  create_table "attractions", :force => true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attractions_categories", :force => true do |t|
    t.integer  "attraction_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calendar_events", :force => true do |t|
    t.string   "name"
    t.datetime "start_at"
    t.datetime "end_at"
    t.boolean  "all_day",      :default => false
    t.string   "event_type"
    t.integer  "itinerary_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "eventful_id"
    t.string   "name"
    t.text     "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "venue"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "postal"
    t.string   "country"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "picture_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.boolean  "confirmed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "geocodes", :force => true do |t|
    t.string   "name"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "state"
    t.string   "country"
    t.integer  "population"
    t.integer  "gtopo30"
    t.integer  "timezone_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "itineraries", :force => true do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.integer  "parent_id"
    t.text     "stringified_data"
    t.integer  "permission_level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "likes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "likable_id"
    t.string   "likable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "poi_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "selected_attractions", :force => true do |t|
    t.integer  "itinerary_id"
    t.integer  "attraction_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "selected_events", :force => true do |t|
    t.integer  "itinerary_id"
    t.integer  "event_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timezones", :force => true do |t|
    t.string   "name"
    t.float    "gmt_offset"
    t.float    "dst_offset"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transportations", :force => true do |t|
    t.integer  "itinerary_id"
    t.integer  "mode"
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "extra_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_sessions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "facebook_id"
    t.datetime "birthday"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_guest",              :default => false
    t.string   "facebook_access_token"
    t.float    "timezone"
    t.string   "locale"
    t.string   "facebook_url"
  end

  add_index "users", ["is_guest"], :name => "altered_users_is_guest_index"

  create_table "zipcars", :force => true do |t|
    t.string   "location"
    t.string   "closest_airport"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
