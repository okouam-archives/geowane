class API::Features < API::Base

  use Rack::JSONP

  before do
    content_type :json
  end

  get '/' do
    coords = params[:bounds].split(',')
    name = params[:q]
    sql = %{
      SELECT
        longitude, latitude, locations.name, boundaries.name "country", locations.feature
      FROM
        locations
        JOIN boundaries ON boundaries.id = locations.level_0
      WHERE
        locations.name ilike '%#{name}%'
        AND ST_Intersects(SetSRID('BOX(#{coords[0]} #{coords[1]},#{coords[2]} #{coords[3]})'::box2d::geometry, 4326), locations.feature)
      UNION
      SELECT
        ST_X(roads.centroid),
        ST_Y(roads.centroid),
        label as name,
        boundaries.name "country",
        centroid as feature
      FROM
        (SELECT
          roads.road_id,
          max(gid) as gid
         FROM roads
         WHERE
          label ilike '%#{name}%'
          AND ST_Intersects(SetSRID('BOX(#{coords[0]} #{coords[1]},#{coords[2]} #{coords[3]})'::box2d::geometry, 4326), roads.centroid)
        GROUP BY roads.road_id
      ) AS x JOIN roads ON x.gid = roads.gid
      JOIN boundaries ON boundaries.id = roads.country_id
LIMIT 99
    }
    Location.find_by_sql(sql).to_a.first(99).to_geojson
  end

end
