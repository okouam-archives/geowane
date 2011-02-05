class CreateCountries < ActiveRecord::Migration
  def self.up
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
    add_column :countries, :feature, :geometry, :limit => nil, :srid => 4326
    add_index "countries", ["feature"], :name => "idx_countries_feature", :spatial => true
  end

  def self.down
    drop_table :countries
  end
end
