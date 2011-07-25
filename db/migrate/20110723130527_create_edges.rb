class CreateEdges < ActiveRecord::Migration
  def self.up
    execute %{
      CREATE TABLE edges
      (
        gid serial NOT NULL,
        road_id integer,
        label character varying(255),
        to_cost float8,
        reverse_cost float8,
        "source" integer,
        "target" integer,
        "length" double precision,
        x1 double precision,
        x2 double precision,
        y1 double precision,
        y2 double precision,
        country_id integer,
        rule text,
        CONSTRAINT roads_pkey PRIMARY KEY (gid)
      );
      SELECT AddGeometryColumn('edges', 'the_geom', 4326, 'LINESTRING', 2);
      SELECT AddGeometryColumn('edges', 'centroid', 4326, 'POINT', 2);
    }
  end

  def self.down
  end
end
