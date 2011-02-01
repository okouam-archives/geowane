class CreateAdministrativeUnits < ActiveRecord::Migration

  def self.up
      create_table :administrative_units, :force => true do |t|
        t.string :name
        t.integer :depth, :null => false
        t.integer :parent_id
      end
      add_column :administrative_units, :feature, :geometry, :limit => nil, :srid => 4326
      execute %{
        INSERT INTO administrative_units (name, parent_id, feature, depth)
        SELECT name, null, the_geom, 0 FROM level0;
        INSERT INTO administrative_units (name, parent_id, feature, depth)
        SELECT name, null, the_geom, 1 FROM level1;
        INSERT INTO administrative_units (name, parent_id, feature, depth)
        SELECT name, null, the_geom, 2 FROM level2;
        INSERT INTO administrative_units (name, parent_id, feature, depth)
        SELECT name, null, the_geom, 3 FROM level3;
        INSERT INTO administrative_units (name, parent_id, feature, depth)
        SELECT name, null, the_geom, 4 FROM level4;
        UPDATE LOCATIONS SET administrative_unit_0 = administrative_units.id
        FROM administrative_units
        WHERE depth = 0
          AND ST_WITHIN(setsrid(locations.feature, 4326), administrative_units.feature);
        UPDATE LOCATIONS SET administrative_unit_1 = administrative_units.id
        FROM administrative_units
        WHERE depth = 1
          AND ST_WITHIN(setsrid(locations.feature, 4326), administrative_units.feature);
        UPDATE LOCATIONS SET administrative_unit_2 = administrative_units.id
        FROM administrative_units
        WHERE depth = 2
          AND ST_WITHIN(setsrid(locations.feature, 4326), administrative_units.feature);
        UPDATE LOCATIONS SET administrative_unit_3 = administrative_units.id
        FROM administrative_units
        WHERE depth = 3
          AND ST_WITHIN(setsrid(locations.feature, 4326), administrative_units.feature);
        UPDATE LOCATIONS SET administrative_unit_4 = administrative_units.id
        FROM administrative_units
        WHERE depth = 4
          AND ST_WITHIN(setsrid(locations.feature, 4326), administrative_units.feature);
      }
  end

  def self.down
  end

end
