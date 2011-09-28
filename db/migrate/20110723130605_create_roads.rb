class CreateRoads < ActiveRecord::Migration

  def up
    execute %{
      CREATE TABLE roads
      (
        id integer,
        label character varying(255),
        country_id integer REFERENCES boundaries(id),
        is_one_way boolean NOT NULL default ,
        route_parameters character varying(100),
        category_id integer REFERENCES categories(id),
        created_at timestamp without time zone,
        updated_at timestamp without time zone,
        CONSTRAINT pkey_roads PRIMARY KEY (id)
      );
      SELECT AddGeometryColumn('roads', 'the_geom', 4326, 'LINESTRING', 2);
      SELECT AddGeometryColumn('roads', 'centroid', 4326, 'POINT', 2);
      CREATE INDEX idx_roads_country_id ON roads(country_id);
      CREATE INDEX idx_roads_category_id ON roads(category_id);
    }
  end

  def down
    execute %{
      DROP TABLE roads;
    }
  end

end
