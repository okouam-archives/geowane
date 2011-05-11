class CreateCitiesTable < ActiveRecord::Migration

  def self.up
    unless table_exists?(:cities)
      create_table :cities do |t|
        t.string :name
      end
      add_column :cities, :feature, :geometry, :srid => 4326
      add_column :cities, :centre, :geometry, :srid => 4326
      add_index "cities", ["feature"], :name => "idx_cities_feature", :spatial => true
      add_index "cities", ["centre"], :name => "idx_cities_centre", :spatial => true
    end
  end

  def self.down
    drop_table :cities if table_exists?(:cities)
  end

end