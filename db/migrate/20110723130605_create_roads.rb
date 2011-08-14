class CreateRoads < ActiveRecord::Migration
  def self.up
    execute %{
      CREATE TABLE roads
      (
        id integer,
        label character varying(255),
        country_id integer,
        is_one_way boolean,
        route_parameters character varying(100),
        category_id integer,
        CONSTRAINT roads_pkey PRIMARY KEY (id)
      );
      SELECT AddGeometryColumn('roads', 'the_geom', 4326, 'LINESTRING', 2);
      SELECT AddGeometryColumn('roads', 'centroid', 4326, 'POINT', 2);
    }
  end

  def self.down
    execute %{DROP TABLE roads;}
  end
end
