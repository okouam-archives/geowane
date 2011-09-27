class CreateLocationsTable < ActiveRecord::Migration

  def change
    create_table :locations, :force => true do |t|
      t.string :name
      t.decimal :longitude
      t.decimal :latitude
      t.enum :status
      t.references :city, :foreign_key => true, :dependent => :restrict
      t.string :city_name
      t.references :user, :foreign_key => true, :dependent => :restrict
      t.string :user_login
      t.references :import, :foreign_key => true, :dependent => :restrict
      t.references :road, :foreign_key => true, :dependent => :restrict
      t.string :long_name
      t.geometry :feature, :srid => 4326
      t.integer :level_0
      t.integer :level_1
      t.integer :level_2
      t.integer :level_3
      t.integer :level_4
      t.string :email
      t.text :metadata
      t.text :boundaries
      t.string :telephone
      t.string :website
      t.string :postal_address
      t.string :opening_hours
      t.string :acronym
      t.string :geographical_address
      t.text :miscellanous
      t.timestamps
    end
    add_index :locations, ["user_id"], :name => "idx_locations_user_id"
    add_index :locations, ["city_id"], :name => "idx_locations_city_id"
    add_index :locations, ["feature"], :name => "idx_locations_feature", :spatial => true
    add_index :locations, ["name"], :name => "idx_locations_name"
    add_index :locations, ["status"], :name => "idx_locations_status"
  end
end

