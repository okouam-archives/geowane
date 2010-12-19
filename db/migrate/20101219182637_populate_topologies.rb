class PopulateTopologies < ActiveRecord::Migration
  def self.up
    execute %{
     INSERT INTO topologies (location_id, commune_id, country_id, city_id, region_id) 
       SELECT
         locations.id, 
         communes.id, 
         countries.id, 
         cities.id, 
         regions.id
       FROM locations
         LEFT JOIN communes on ST_Within(locations.feature, communes.feature)
         LEFT JOIN countries on ST_Within(locations.feature, countries.feature)
         LEFT JOIN regions on ST_Within(locations.feature, regions.feature)
         LEFT JOIN cities on ST_Within(locations.feature, cities.feature)
    }
  end

  def self.down
    execute "TRUNCATE TABLE topologies"
  end
end
