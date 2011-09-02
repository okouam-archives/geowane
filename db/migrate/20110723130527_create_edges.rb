class CreateEdges < ActiveRecord::Migration
  def up
    execute %{
      CREATE TABLE edges
      (
        gid serial NOT NULL,
        road_id integer,
        label character varying(255),
        to_cost float8,
        cost float8,
        reverse_cost float8,
        "source" integer,
        "target" integer,
        "length" double precision,
        x1 double precision,
        x2 double precision,
        y1 double precision,
        y2 double precision,
        cost_multiplier double precision,
        is_one_way boolean,
        rule text,
        CONSTRAINT edges_pkey PRIMARY KEY (gid)
      );
      SELECT AddGeometryColumn('edges', 'the_geom', 4326, 'LINESTRING', 2);
      SELECT AddGeometryColumn('edges', 'centroid', 4326, 'POINT', 2);
    }
  end
end
