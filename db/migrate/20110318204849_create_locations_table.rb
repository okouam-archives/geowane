class CreateLocationsTable < ActiveRecord::Migration

  def self.up
    unless table_exists?(:locations)
      create_table :locations, :force => true do |t|
        t.string :name
        t.decimal :longitude
        t.decimal :latitude
        t.string :email
        t.string :telephone
        t.enum :status
        t.references :city, :foreign_key => true, :dependent => :restrict
        t.references :user, :foreign_key => true, :dependent => :restrict
        t.string :fax
        t.string :website
        t.string :postal_address
        t.string :opening_hours
        t.integer :user_rating
        t.references :import, :foreign_key => true, :dependent => :restrict
        t.string :long_name
        t.geometry :feature, :srid => 4326
        t.integer :level_0
        t.integer :level_1
        t.integer :level_2
        t.integer :level_3
        t.integer :level_4
        t.timestamps
      end
      add_index :locations, ["feature"], :name => "idx_locations_feature", :spatial => true
      add_index :locations, ["name"], :name => "idx_features_name"
    end
  end

  def self.down
    drop_table :locations if table_exists?(:locations)
  end

end

