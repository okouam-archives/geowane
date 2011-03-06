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

    create_table :cities do |t|
      t.string :name
    end
    add_column :cities, :feature, :geometry, :srid => 4326
    add_index "cities", ["feature"], :name => "idx_cities_feature", :spatial => true

    create_table :locations, :force => true do |t|
      t.string :name
      t.decimal :longitude
      t.decimal :latitude
      t.string :email
      t.string :telephone
      t.enum :status
      t.references :city
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

    create_table :sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end
    add_index :sessions, :session_id
    add_index :sessions, :updated_at

    create_table :comments do |t|
      t.string :title, :limit => 50, :default => ""
      t.text :comment
      t.references :commentable, :polymorphic => true
      t.references :user
      t.timestamps
    end

    add_index :comments, :commentable_type
    add_index :comments, :commentable_id
    add_index :comments, :user_id

    create_table :model_changes, :force => true do |t|
      t.column :old_value, :string
      t.references :audit
      t.column :new_value, :string
      t.column :datum, :string
    end

    create_table :imports, :force => true do |t|
      t.integer :locations_count, :default => 0
      t.string :input_file_name
      t.string :input_content_type
      t.integer :input_file_size
      t.datetime :input_updated_at
      t.enum :import_format
      t.references :user
      t.timestamps
    end

  end

end
