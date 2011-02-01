class CreateLocations < ActiveRecord::Migration

  def self.up

    create_table :locations, :force => true do |t|
      t.integer  :category_id
      t.string   :name
      t.decimal  :longitude
      t.decimal  :latitude
      t.string   :email
      t.string   :telephone
      t.enum   :status
      t.integer  :user_id
      t.string   :fax
      t.string   :website
      t.string   :postal_address
      t.string   :opening_hours
      t.integer  :user_rating
      t.timestamps
    end

    add_column :locations, :import_id, :integer
    add_column :locations, :long_name, :string
    add_column :locations, :feature, :geometry, :limit => nil, :srid => 4326
    add_index "locations", ["feature"], :name => "idx_locations_feature", :spatial => true
    add_index :locations, ["name"], :name => "idx_features_name"

  end

  def self.down
    drop_table :locations
  end
  
end
