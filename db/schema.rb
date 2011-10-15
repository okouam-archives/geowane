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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111005181026) do

  create_table "boundaries", :force => true do |t|
    t.string   "name",                          :null => false
    t.integer  "level",                         :null => false
    t.string   "classification",                :null => false
    t.integer  "parent_id"
    t.geometry "feature",        :limit => nil,                 :srid => 4326
  end

  add_index "boundaries", ["feature"], :name => "idx_administrative_units_feature", :spatial => true
  add_index "boundaries", ["level"], :name => "idx_administrative_units_level"

  create_table "categories", :force => true do |t|
    t.string   "french"
    t.string   "english"
    t.string   "icon"
    t.boolean  "is_hidden",   :default => false, :null => false
    t.boolean  "is_landmark", :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["is_hidden"], :name => "idx_categories_is_hidden"
  add_index "categories", ["is_landmark"], :name => "idx_categories_is_landmark"

  create_table "changes", :force => true do |t|
    t.string   "old_value"
    t.integer  "changeset_id"
    t.string   "new_value"
    t.string   "datum"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "changesets", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "user_id"
    t.string   "action"
  end

  add_index "changesets", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "changesets", ["created_at"], :name => "index_changesets_on_created_at"
  add_index "changesets", ["user_id"], :name => "user_index"

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.geometry "feature", :limit => nil, :srid => 4326
    t.geometry "centre",  :limit => nil, :srid => 4326
  end

  add_index "cities", ["centre"], :name => "idx_cities_centre", :spatial => true
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

  create_table "conversions", :force => true do |t|
    t.string   "input_file_name"
    t.string   "input_content_type"
    t.string   "string"
    t.integer  "input_file_size"
    t.integer  "integer"
    t.string   "input_format"
    t.datetime "input_updated_at"
    t.datetime "datetime"
    t.string   "output_file_name"
    t.string   "output_content_type"
    t.integer  "output_file_size"
    t.string   "output_format"
    t.datetime "output_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "edges", :primary_key => "gid", :force => true do |t|
    t.integer     "road_id"
    t.string      "label"
    t.float       "to_cost"
    t.float       "cost"
    t.float       "reverse_cost"
    t.integer     "source"
    t.integer     "target"
    t.float       "length"
    t.float       "x1"
    t.float       "x2"
    t.float       "y1"
    t.float       "y2"
    t.float       "cost_multiplier"
    t.boolean     "is_one_way"
    t.text        "rule"
    t.line_string "the_geom",        :limit => nil, :srid => 4326
  end

  add_index "edges", ["road_id"], :name => "idx_edges_road_id"

  create_table "exports", :force => true do |t|
    t.integer  "locations_count"
    t.integer  "user_id"
    t.string   "output_file_name"
    t.string   "output_content_type"
    t.integer  "output_file_size"
    t.string   "output_format"
    t.datetime "output_updated_at"
    t.string   "output_platform"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "features", :force => true do |t|
    t.integer  "end_level"
    t.boolean  "one_way"
    t.string   "label"
    t.integer  "level"
    t.integer  "road_id"
    t.integer  "road_class"
    t.integer  "speed"
    t.integer  "type"
    t.geometry "geom",       :limit => nil, :srid => 4326
  end

  add_index "features", ["geom"], :name => "idx_features_geom", :spatial => true

  create_table "imports", :force => true do |t|
    t.integer  "locations_count",    :default => 0
    t.string   "input_file_name"
    t.string   "input_content_type"
    t.integer  "input_file_size"
    t.datetime "input_updated_at"
    t.string   "import_format"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.decimal  "longitude"
    t.decimal  "latitude"
    t.string   "status"
    t.integer  "city_id"
    t.string   "city_name"
    t.integer  "user_id"
    t.string   "user_login"
    t.integer  "import_id"
    t.integer  "road_id"
    t.string   "long_name"
    t.integer  "level_0"
    t.integer  "level_1"
    t.integer  "level_2"
    t.integer  "level_3"
    t.integer  "level_4"
    t.string   "email"
    t.text     "metadata"
    t.text     "boundaries"
    t.string   "telephone"
    t.string   "website"
    t.string   "postal_address"
    t.string   "opening_hours"
    t.string   "acronym"
    t.string   "geographical_address"
    t.text     "miscellanous"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.geometry "feature",              :limit => nil, :srid => 4326
  end

  add_index "locations", ["city_id"], :name => "idx_locations_city_id"
  add_index "locations", ["feature"], :name => "idx_locations_feature", :spatial => true
  add_index "locations", ["name"], :name => "idx_locations_name"
  add_index "locations", ["status"], :name => "idx_locations_status"
  add_index "locations", ["user_id"], :name => "idx_locations_user_id"

  create_table "logos", :force => true do |t|
    t.integer  "location_id"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.integer  "location_id"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roads", :id => false, :force => true do |t|
    t.integer     "id",                              :null => false
    t.string      "label"
    t.integer     "country_id"
    t.boolean     "is_one_way",                      :null => false
    t.string      "route_parameters", :limit => 100
    t.integer     "category_id"
    t.datetime    "created_at"
    t.datetime    "updated_at"
    t.line_string "the_geom",         :limit => nil,                 :srid => 4326
    t.point       "centroid",         :limit => nil,                 :srid => 4326
  end

  add_index "roads", ["category_id"], :name => "idx_roads_category_id"
  add_index "roads", ["country_id"], :name => "idx_roads_country_id"

  create_table "rules", :id => false, :force => true do |t|
    t.integer  "id",          :null => false
    t.string   "french"
    t.string   "english"
    t.integer  "category_id"
    t.integer  "ruleset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rules", ["category_id"], :name => "idx_rules_category_id"
  add_index "rules", ["ruleset_id"], :name => "idx_rules_ruleset_id"

  create_table "rulesets", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "search_criteria", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "search_id"
    t.string   "sort"
    t.integer  "classification_id"
    t.string   "bbox"
    t.integer  "import_id"
    t.integer  "added_by"
    t.boolean  "category_missing"
    t.boolean  "category_present"
    t.integer  "category_id"
    t.integer  "confirmed_by"
    t.integer  "invalidated_by"
    t.integer  "corrected_by"
    t.integer  "audited_by"
    t.integer  "modified_by"
    t.integer  "city_id"
    t.string   "added_on_after"
    t.string   "added_on_before"
    t.string   "name"
    t.string   "status"
    t.integer  "radius"
    t.integer  "level_id"
    t.integer  "location_level_0"
    t.integer  "location_level_1"
    t.integer  "location_level_2"
    t.integer  "location_level_3"
    t.integer  "location_level_4"
    t.string   "street_name"
    t.string   "sort_order"
  end

  create_table "selections", :force => true do |t|
    t.string   "name",        :null => false
    t.decimal  "longitude",   :null => false
    t.decimal  "latitude",    :null => false
    t.string   "comment"
    t.integer  "original_id"
    t.integer  "import_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "selections", ["import_id"], :name => "idx_selections_import_id"
  add_index "selections", ["original_id"], :name => "idx_selections_original_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "tags", :force => true do |t|
    t.integer  "location_id", :null => false
    t.integer  "category_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["category_id", "location_id", "id"], :name => "idx_tags_categories"
  add_index "tags", ["location_id", "category_id", "id"], :name => "idx_tags_locations"

  create_table "users", :force => true do |t|
    t.string   "login",                               :null => false
    t.string   "email",                               :null => false
    t.string   "crypted_password",                    :null => false
    t.string   "password_salt",                       :null => false
    t.string   "persistence_token",                   :null => false
    t.datetime "last_login_at"
    t.string   "last_login_ip"
    t.string   "role_name"
    t.boolean  "is_active",         :default => true, :null => false
    t.string   "mobile_number"
    t.string   "skype_alis"
    t.string   "home_country"
    t.string   "locale",            :default => "en"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
