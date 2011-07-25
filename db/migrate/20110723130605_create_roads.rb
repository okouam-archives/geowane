class CreateRoads < ActiveRecord::Migration
  def self.up
    execute %{
      CREATE OR REPLACE VIEW roads AS
       SELECT edges.gid, edges.road_id, edges.label, edges.to_cost, edges.reverse_cost, edges.source, edges.target, edges.length, edges.x1, edges.x2, edges.y1, edges.y2, edges.country_id, edges.rule, edges.the_geom, edges.centroid
         FROM ( SELECT edges.road_id, max(edges.gid) AS gid
                 FROM edges
                GROUP BY edges.road_id) x
         JOIN edges ON x.gid = edges.gid;
    }
  end

  def self.down
  end
end
