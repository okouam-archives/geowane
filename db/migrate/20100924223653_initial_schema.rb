class InitialSchema < ActiveRecord::Migration

  def self.up

    create_table :categories, :force => true do |t|
      t.string :french, :limit => 200
      t.string :english, :limit => 200
      t.string :code, :limit => 200
      t.string :classification, :limit => 100
      t.string :icon, :limit => 200
      t.boolean :visible, :default => true
      t.integer :numeric_code, :default => 0
      t.integer :total_locations, :default => 0
      t.integer :new_locations, :default => 0
      t.integer :invalid_locations, :default => 0
      t.integer :corrected_locations, :default => 0
      t.integer :audited_locations, :default => 0
      t.integer :field_checked_locations, :default => 0
      t.string :navitel_french
      t.string :navitel_english
      t.string :navitel_code
      t.string :navteq_french
      t.string :navteq_english
      t.string :navteq_code
      t.string :garmin_french
      t.string :garmin_english
      t.string :sygic_french
      t.string :sygic_english
      t.string :sygic_code
      t.integer :level, :default => 0, :null => false
      t.integer :end_level, :default => 0, :null => false
      t.timestamps
    end

    create_table :users do |t|
      t.string :login, :null => false
      t.string :email, :null => false
      t.string :crypted_password, :null => false
      t.string :password_salt, :null => false
      t.string :persistence_token, :null => false
      t.string :single_access_token, :null => false
      t.string :perishable_token, :null => false
      t.integer :login_count, :null => false, :default => 0
      t.integer :failed_login_count, :null => false, :default => 0
      t.datetime :last_request_at
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.string :current_login_ip
      t.string :last_login_ip
      t.string :role_name
      t.boolean :is_active, :default => true, :null => false
      t.string :mobile_number
      t.string :skype_alis
      t.string :home_country
      t.timestamps
    end

    create_table :locations, :force => true do |t|
      t.string :name
      t.decimal :longitude
      t.decimal :latitude
      t.string :email
      t.string :telephone
      t.enum :status
      t.references :user
      t.string :fax
      t.string :website
      t.string :postal_address
      t.string :opening_hours
      t.integer :user_rating
      t.references :import
      t.string :long_name
      t.geometry :feature, :srid => 4326
      t.timestamps
    end

    add_column :locations, :level_0, :integer
    add_column :locations, :level_1, :integer
    add_column :locations, :level_2, :integer
    add_column :locations, :level_3, :integer
    add_column :locations, :level_4, :integer

    add_index :locations, ["feature"], :name => "idx_locations_feature", :spatial => true
    add_index :locations, ["name"], :name => "idx_features_name"

    create_table :regions do |t|
      t.string :name
    end

    add_column :regions, :uncategorized_locations, :integer
    add_column :regions, :total_locations, :integer
    add_column :regions, :new_locations, :integer
    add_column :regions, :invalid_locations, :integer
    add_column :regions, :corrected_locations, :integer
    add_column :regions, :audited_locations, :integer
    add_column :regions, :field_checked_locations, :integer
    add_column :regions, :feature, :geometry, :srid => 4326
    add_index "regions", ["feature"], :name => "idx_regions_feature", :spatial => true

    create_table :communes do |t|
      t.string :name
    end

    add_column :communes, :uncategorized_locations, :integer
    add_column :communes, :total_locations, :integer
    add_column :communes, :new_locations, :integer
    add_column :communes, :invalid_locations, :integer
    add_column :communes, :corrected_locations, :integer
    add_column :communes, :audited_locations, :integer
    add_column :communes, :field_checked_locations, :integer
    add_column :communes, :feature, :geometry, :srid => 4326
    add_index "communes", ["feature"], :name => "idx_communes_feature", :spatial => true

    create_table :cities do |t|
      t.string :name
    end
    add_column :cities, :uncategorized_locations, :integer
    add_column :cities, :total_locations, :integer
    add_column :cities, :new_locations, :integer
    add_column :cities, :invalid_locations, :integer
    add_column :cities, :corrected_locations, :integer
    add_column :cities, :audited_locations, :integer
    add_column :cities, :field_checked_locations, :integer
    add_column :cities, :feature, :geometry, :srid => 4326
    add_index "cities", ["feature"], :name => "idx_cities_feature", :spatial => true

    execute %{
      create or replace function to_dec(character varying)
       returns integer as $$
       declare r int;
       begin
         execute E'select x\\''||$1|| E'\\'::integer' into r;
         return r;
       end
       $$ language plpgsql;
    }

    create_table :countries do |t|
      t.string :name
    end
    add_column :countries, :uncategorized_locations, :integer
    add_column :countries, :total_locations, :integer
    add_column :countries, :new_locations, :integer
    add_column :countries, :invalid_locations, :integer
    add_column :countries, :corrected_locations, :integer
    add_column :countries, :audited_locations, :integer
    add_column :countries, :field_checked_locations, :integer
    add_column :countries, :feature, :geometry, :srid => 4326
    add_index "countries", ["feature"], :name => "idx_countries_feature", :spatial => true

    create_table :sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end
    add_index :sessions, :session_id
    add_index :sessions, :updated_at

  end

  def self.down
    drop_table :sessions
  end

end
