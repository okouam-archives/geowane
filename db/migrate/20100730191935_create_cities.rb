class CreateCities < ActiveRecord::Migration

  def self.up
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
    add_column :cities, :feature, :geometry, :limit => nil, :srid => 4326
    add_index "cities", ["feature"], :name => "idx_cities_feature", :spatial => true
  end

  def self.down
    drop_table :cities
  end

end
