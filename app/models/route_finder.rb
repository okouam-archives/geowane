class RouteFinder

  def find(start_point, end_point)
    start_edge = route_finder.find_closest_edge(start_point)
    destination_edge = route_finder.find_closest_edge(end_point)
    route = find_route(start_edge, destination_edge)
    route = align_roads(route)
    directions = route_finder.create_directions(route)
    {route: route, textual: directions}
  end

  def find_closest_edge(x, y)
    sql = %{
      SELECT
        gid, distance(the_geom, GeometryFromText('POINT(#{y} #{x})', 4326)) as dist
      FROM
        roads
      WHERE
        the_geom && setsrid('BOX3D(#{y.to_i-2} #{x.to_i-2}, #{y.to_i+2} #{x.to_i+2})'::box3d, 4326)
       ORDER BY dist LIMIT 1;
    }
    rs = Location.connection.execute(sql)
    rs[0]["gid"].to_i
  end

  def find_route(start_edge, destination_edge)
    sql = %{
      SELECT
        AsText(rt.the_geom) AS wkt, roads.label
      FROM
        roads,
        (SELECT gid, the_geom
          FROM shootingstar_sp('roads', #{start_edge}, #{destination_edge}, 5000, 'length', true, true)) as rt
          WHERE roads.gid = rt.gid;
    }
    geofactory = RGeo::Geographic.spherical_factory
    Location.connection.execute(sql).map {|x| [geofactory.parse_wkt(x["wkt"]), x["label"]]}
  end

  def create_directions(route)
    directions = []
    0.upto(route.size - 2) do |i|
      first = route[i][0]
      second = route[i+1][0]
      from = route[i][1]
      to = route[i + 1][1]
      case angle(first.points[first.points.size - 2], second.points[0], second.points[1])
        when 0 then
          directions << "straight"
        when 1 then
          directions << "turn left"
        else
          directions << "turn right"
      end
    end
    directions
  end

  def angle(x, y, z)
    0
  end

end