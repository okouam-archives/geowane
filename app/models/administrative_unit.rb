require 'rgeo'
require 'rgeo/shapefile'

class AdministrativeUnit < ActiveRecord::Base

  def self.dropdown_items(depth)
    sql = "SELECT id, name FROM administrative_units WHERE level = #{depth} ORDER BY name ASC"
    AdministrativeUnit.connection.select_all(sql).map {|rs| [rs["name"], rs["id"]]}
  end
  
  def self.find_enclosing(longitude, latitude, depth)
    result = AdministrativeUnit.find_by_sql(%{
      SELECT
        *
      FROM
        administrative_units
      WHERE
        level = #{depth}
        AND ST_WITHIN(ST_SetSRID(ST_POINT(#{longitude}, #{latitude}), 4326), administrative_units.feature)
    })
    result.is_a?(Array) ? result.first : result 
  end

  def self.load_from_resources

    ActiveRecord::Base.connection.execute %{
      ALTER TABLE administrative_units DROP CONSTRAINT "enforce_srid_the_geom" RESTRICT;
    }

    ic = Iconv.new('UTF-8//TRANSLIT//IGNORE', 'LATIN1')
    ["BENIN", "BURKINA FASO", "GHANA", "GUINEA", "IVORY COAST", "MALI", "SENEGAL", "TOGO"].each do |directory|
      for i in 0..5 do
        file = File.join(Rails.root, "db/resources/administrative units/#{directory}/LEVEL_#{i}.shp")
        if File.exists?(file)
          RGeo::Shapefile::Reader.open(file) do |shp|
            shp.each do |shape|
              feature = shape.geometry
              name = ic.iconv(shape.attributes["Name"])
              type = ic.iconv(shape.attributes["Type"])
              begin
                AdministrativeUnit.create!(:name => name, :classification => type, :level => i, :feature => feature)
              rescue Exception => e
                raise e
              end
            end
          end
        end
      end
    end

    ActiveRecord::Base.connection.execute %{
      UPDATE administrative_units SET feature = ST_SetSRID(feature,4326);
      ALTER TABLE administrative_units ADD CONSTRAINT "enforce_srid_the_geom" CHECK (SRID(feature)=4326);
    }

    ActiveRecord::Base.connection.execute %{
            UPDATE
              locations
            SET
              level_0 = administrative_units.id
            FROM
              administrative_units
            WHERE
              level = 0
              AND ST_WITHIN(setsrid(locations.feature, 4326), administrative_units.feature);

            UPDATE
              locations
            SET
              level_1 = administrative_units.id
            FROM
              administrative_units
            WHERE level = 1
              AND ST_WITHIN(setsrid(locations.feature, 4326), administrative_units.feature);

            UPDATE
              locations
            SET
              level_2 = administrative_units.id
            FROM
              administrative_units
            WHERE
              level = 2
              AND ST_WITHIN(setsrid(locations.feature, 4326), administrative_units.feature);

            UPDATE
              locations
            SET level_3 = administrative_units.id
            FROM
              administrative_units
            WHERE
              level = 3
              AND ST_WITHIN(setsrid(locations.feature, 4326), administrative_units.feature);

            UPDATE
              locations
            SET
              level_4 = administrative_units.id
            FROM
              administrative_units
            WHERE
              level = 4
              AND ST_WITHIN(setsrid(locations.feature, 4326), administrative_units.feature);
    }
  end

end