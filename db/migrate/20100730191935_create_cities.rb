class CreateCities < ActiveRecord::Migration

  def self.up
    create_table :cities do |t|
      t.string :name
    end
    add_column :cities, :feature, :geometry, :limit => nil, :srid => 4326
    add_index "cities", ["feature"], :name => "idx_cities_feature", :spatial => true
  end

  def self.down
    drop_table :cities
  end

end
