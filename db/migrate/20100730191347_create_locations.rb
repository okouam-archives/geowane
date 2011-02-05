class CreateLocations < ActiveRecord::Migration

  def self.up
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
      t.integer:user_rating
      t.references :import
      t.string :long_name
      t.timestamps
    end
    add_column :locations, :tags_count, :integer, :default => 0   
    add_column :locations, :feature, :geometry, :limit => nil, :srid => 4326
    add_index :locations, ["feature"], :name => "idx_locations_feature", :spatial => true
    add_index :locations, ["name"], :name => "idx_features_name"
  end

  def self.down
    drop_table :locations
  end
  
end
