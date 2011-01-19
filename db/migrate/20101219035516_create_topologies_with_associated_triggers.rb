class CreateTopologiesWithAssociatedTriggers < ActiveRecord::Migration
  def self.up
    
    create_table :topologies, :force => true do |t|
      t.references :location
      t.references :country
      t.references :region
      t.references :commune
      t.references :city
      t.timestamps
    end

  execute %(
    CREATE OR REPLACE FUNCTION topology_change() RETURNS trigger AS '
        DECLARE
        BEGIN
          IF tg_op = ''DELETE'' THEN
             DELETE FROM topologies WHERE topologies.location_id = OLD.id;
             RETURN NULL;
          END IF;
          IF tg_op = ''INSERT'' THEN
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
              WHERE locations.id = NEW.id;
          ELSE
              IF (OLD.longitude != NEW.longitude) OR (NEW.latitude != OLD.latitude) THEN
                UPDATE topologies 
                SET 
                  country_id = countries.id, 
                  region_id = regions.id, 
                  city_id = cities.id, 
                  commune_id = communes.id 
                FROM locations
                LEFT JOIN 
                  communes on ST_Within(locations.feature, communes.feature)
                LEFT JOIN 
                  countries on ST_Within(locations.feature, countries.feature)
                LEFT JOIN 
                  regions on ST_Within(locations.feature, regions.feature)
                LEFT JOIN 
                  cities on ST_Within(locations.feature, cities.feature)        
                WHERE 
                  topologies.location_id = NEW.id
                  AND topologies.location_id = locations.id;
              END IF;
          END IF;
          RETURN NULL;
        END
        ' LANGUAGE plpgsql;

    CREATE TRIGGER topology_change AFTER INSERT OR DELETE OR UPDATE ON locations
    FOR EACH ROW EXECUTE PROCEDURE topology_change();  
  )    

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
  end
end
