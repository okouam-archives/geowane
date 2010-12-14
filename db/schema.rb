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

ActiveRecord::Schema.define(:version => 20101128161450) do

  create_table "audits", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "user_id"
    t.string   "action"
  end

  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id"], :name => "user_index"

  create_table "categories", :force => true do |t|
    t.string  "french",          :limit => 200
    t.string  "english",         :limit => 200
    t.string  "code",            :limit => 200
    t.string  "classification",  :limit => 100
    t.string  "icon",            :limit => 200
    t.boolean "visible"
    t.integer "numeric_code"
    t.string  "navitel_french"
    t.string  "navitel_english"
    t.string  "navitel_code"
    t.string  "navteq_french"
    t.string  "navteq_english"
    t.string  "navteq_code"
    t.string  "garmin_french"
    t.string  "garmin_english"
    t.string  "sygic_french"
    t.string  "sygic_english"
    t.string  "sygic_code"
  end

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.geometry "feature", :limit => nil, :srid => 4326
  end

  add_index "cities", ["feature"], :name => "idx_cities_feature", :spatial => true

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "communes", :force => true do |t|
    t.string   "name"
    t.geometry "feature", :limit => nil, :srid => 4326
  end

  add_index "communes", ["feature"], :name => "idx_communes_feature", :spatial => true

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.geometry "feature", :limit => nil, :srid => 4326
  end

  add_index "countries", ["feature"], :name => "idx_countries_feature", :spatial => true

  create_table "events", :force => true do |t|
    t.integer  "location_id"
    t.integer  "user_id"
    t.string   "label",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.integer  "category_id"
    t.string   "name"
    t.decimal  "longitude"
    t.decimal  "latitude"
    t.string   "searchable_name"
    t.string   "email"
    t.string   "telephone"
    t.string   "status"
    t.integer  "user_id"
    t.string   "fax"
    t.string   "website"
    t.string   "postal_address"
    t.string   "opening_hours"
    t.integer  "user_rating"
    t.geometry "feature",         :limit => nil, :srid => 4326
  end

  add_index "locations", ["feature"], :name => "idx_locations_feature", :spatial => true
  add_index "locations", ["name"], :name => "idx_features_name"

  create_table "model_changes", :force => true do |t|
    t.string  "old_value"
    t.integer "audit_id"
    t.string  "new_value"
    t.string  "datum"
  end

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.geometry "feature", :limit => nil, :srid => 4326
  end

  add_index "regions", ["feature"], :name => "idx_regions_feature", :spatial => true

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "shapefiles", :force => true do |t|
    t.string "filename"
    t.string "locations"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                                 :null => false
    t.string   "email",                                 :null => false
    t.string   "crypted_password",                      :null => false
    t.string   "password_salt",                         :null => false
    t.string   "persistence_token",                     :null => false
    t.string   "single_access_token",                   :null => false
    t.string   "perishable_token",                      :null => false
    t.integer  "login_count",         :default => 0,    :null => false
    t.integer  "failed_login_count",  :default => 0,    :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "role_name"
    t.boolean  "is_active",           :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mobile_number"
    t.string   "skype_alias"
    t.string   "home_country"
  end

end
