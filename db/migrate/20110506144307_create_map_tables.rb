class CreateMapTables < ActiveRecord::Migration
  def self.up
    execute %{
      CREATE TABLE osm_line
      (
        osm_id integer,
        "access" text,
        "addr:flats" text,
        "addr:housenumber" text,
        "addr:interpolation" text,
        admin_level text,
        aerialway text,
        aeroway text,
        amenity text,
        area text,
        barrier text,
        bicycle text,
        bridge text,
        boundary text,
        building text,
        construction text,
        cutting text,
        disused text,
        embankment text,
        foot text,
        highway text,
        historic text,
        horse text,
        junction text,
        landuse text,
        layer text,
        learning text,
        leisure text,
        "lock" text,
        man_made text,
        military text,
        motorcar text,
        "name" text,
        "natural" text,
        oneway text,
        "operator" text,
        power text,
        power_source text,
        place text,
        railway text,
        ref text,
        religion text,
        residence text,
        route text,
        service text,
        shop text,
        sport text,
        tourism text,
        tracktype text,
        tunnel text,
        waterway text,
        width text,
        wood text,
        z_order integer,
        way_area real,
        way geometry
      );
      CREATE INDEX osm_line_index ON osm_line USING gist (way);
      CREATE TABLE osm_point
      (
        osm_id integer,
        "access" text,
        "addr:flats" text,
        "addr:housenumber" text,
        "addr:interpolation" text,
        admin_level text,
        aerialway text,
        aeroway text,
        amenity text,
        area text,
        barrier text,
        bicycle text,
        bridge text,
        boundary text,
        building text,
        construction text,
        cutting text,
        disused text,
        embankment text,
        foot text,
        highway text,
        historic text,
        horse text,
        junction text,
        landuse text,
        layer text,
        learning text,
        leisure text,
        "lock" text,
        man_made text,
        military text,
        motorcar text,
        "name" text,
        "natural" text,
        oneway text,
        "operator" text,
        power text,
        power_source text,
        place text,
        railway text,
        ref text,
        religion text,
        residence text,
        route text,
        service text,
        shop text,
        sport text,
        tourism text,
        tracktype text,
        tunnel text,
        waterway text,
        width text,
        wood text,
        z_order integer,
        way_area real,
        way geometry
      );
      CREATE INDEX osm_point_index ON osm_point USING gist (way);
      CREATE TABLE osm_polygon
      (
        osm_id integer,
        "access" text,
        "addr:flats" text,
        "addr:housenumber" text,
        "addr:interpolation" text,
        admin_level text,
        aerialway text,
        aeroway text,
        amenity text,
        area text,
        barrier text,
        bicycle text,
        bridge text,
        boundary text,
        building text,
        construction text,
        cutting text,
        disused text,
        embankment text,
        foot text,
        highway text,
        historic text,
        horse text,
        junction text,
        landuse text,
        layer text,
        learning text,
        leisure text,
        "lock" text,
        man_made text,
        military text,
        motorcar text,
        "name" text,
        "natural" text,
        oneway text,
        "operator" text,
        power text,
        power_source text,
        place text,
        railway text,
        ref text,
        religion text,
        residence text,
        route text,
        service text,
        shop text,
        sport text,
        tourism text,
        tracktype text,
        tunnel text,
        waterway text,
        width text,
        wood text,
        z_order integer,
        way_area real,
        way geometry
      );
      CREATE INDEX osm_polygon_index ON osm_polygon USING gist (way);
      CREATE TABLE osm_roads
      (
        osm_id integer,
        "access" text,
        "addr:flats" text,
        "addr:housenumber" text,
        "addr:interpolation" text,
        admin_level text,
        aerialway text,
        aeroway text,
        amenity text,
        area text,
        barrier text,
        bicycle text,
        bridge text,
        boundary text,
        building text,
        construction text,
        cutting text,
        disused text,
        embankment text,
        foot text,
        highway text,
        historic text,
        horse text,
        junction text,
        landuse text,
        layer text,
        learning text,
        leisure text,
        "lock" text,
        man_made text,
        military text,
        motorcar text,
        "name" text,
        "natural" text,
        oneway text,
        "operator" text,
        power text,
        power_source text,
        place text,
        railway text,
        ref text,
        religion text,
        residence text,
        route text,
        service text,
        shop text,
        sport text,
        tourism text,
        tracktype text,
        tunnel text,
        waterway text,
        width text,
        wood text,
        z_order integer,
        way_area real,
        way geometry
      );
      CREATE INDEX osm_roads_index ON osm_roads USING gist (way);
  }
  end

  def self.down
  end
end
