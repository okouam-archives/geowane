class CreateCountries < ActiveRecord::Migration
 def self.up
    create_table :countries do |t|
      t.string :name
    end
    add_column :countries, :feature, :geometry, :limit => nil, :srid => 4326
    add_index "countries", ["feature"], :name => "idx_countries_feature", :spatial => true
  end

  def self.down
    drop_table :countries
  end
end
