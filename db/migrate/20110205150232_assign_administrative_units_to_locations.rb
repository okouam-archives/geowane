class AssignAdministrativeUnitsToLocations < ActiveRecord::Migration

  def self.up
    execute %{
        UPDATE
          locations
        SET
          level_0 = administrative_units.id
        FROM
          administrative_units
        WHERE
          depth = 0
          AND ST_WITHIN(setsrid(locations.feature, 4326), administrative_units.feature);

        UPDATE
          locations
        SET
          level_1 = administrative_units.id
        FROM
          administrative_units
        WHERE depth = 1
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

  def self.down
  end
  
end
