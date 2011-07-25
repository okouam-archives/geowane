class CreateEdges < ActiveRecord::Migration
  def self.up
    execute %{
      CREATE TABLE edges
      (
        gid integer NOT NULL DEFAULT nextval('roads_gid_seq'::regclass),
        road_id integer,
        label character varying(255),
        to_cost double precision,
        reverse_cost double precision,
        source integer,
        target integer,
        length double precision,
        x1 double precision,
        x2 double precision,
        y1 double precision,
        y2 double precision,
        country_id integer,
        rule text,
        the_geom geometry,
        centroid geometry,
        CONSTRAINT roads_pkey PRIMARY KEY (gid),
        CONSTRAINT enforce_dims_centroid CHECK (st_ndims(centroid) = 2),
        CONSTRAINT enforce_dims_the_geom CHECK (st_ndims(the_geom) = 2),
        CONSTRAINT enforce_geotype_centroid CHECK (geometrytype(centroid) = 'POINT'::text OR centroid IS NULL),
        CONSTRAINT enforce_geotype_the_geom CHECK (geometrytype(the_geom) = 'LINESTRING'::text OR the_geom IS NULL),
        CONSTRAINT enforce_srid_centroid CHECK (st_srid(centroid) = 4326),
        CONSTRAINT enforce_srid_the_geom CHECK (st_srid(the_geom) = 4326)
      )
    }
  end

  def self.down
  end
end
