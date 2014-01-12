class CreateCitiesTable < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
    end
    add_column :cities, :feature, :geometry, :srid => 4326
    add_column :cities, :centre, :geometry, :srid => 4326
    add_index "cities", %w(feature), :name => "idx_cities_feature", :spatial => true
    add_index "cities", %w(centre), :name => "idx_cities_centre", :spatial => true
  end
end