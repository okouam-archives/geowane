class Navigator

  def initialize
    @geofactory = RGeo::Geographic.spherical_factory
  end

  def find_route(x1, y1, x2, y2)
    sql = "SELECT * FROM find_closest_edge(#{x1}, #{y1}, #{x2}, #{y2})"
    rs = Location.connection.execute(sql)
    route = rs.map do |x|
      geometry = @geofactory.parse_wkt(x["a"])
      feature = RGeo::GeoJSON::Feature.new(geometry)
      [feature, x["b"]]
    end
    {segments: route.map{|x|x[0]}, labels: route.map{|x|x[0]}}
  end

  def cleanup(x1, y1, x2, y2, features)
    points = features[0].geometry.points
    features[0] = closest_point(x1, y1, points, features[1].geometry)
    last_index = features.size - 1
    points = features[last_index].geometry.points
    features[last_index] = closest_point(x2, y2, points, features[last_index -1].geometry)
    features

  end

  def closest_point(x, y, road, neighbour)
    marker = @geofactory.point(y, x)
    segments = split(marker, road)

    if segments[0].first == neighbour.points.first || segments[0].first == neighbour.points.last
      correct = segments[0]
      points = correct + [marker]
    elsif segments[1].last == neighbour.points.first || segments[1].last == neighbour.points.last
      correct = segments[1]
      points = [marker] + correct
    else
      raise "What a mystery!"
    end

    RGeo::GeoJSON::Feature.new(geofactory.line_string(points))

  end

  def split(marker, road)
    min, index = -1
    0.upto(road.size - 1) do |i|
      dist = marker.distance(road[i])
      if min < 0 || dist < min
        index = i
        min = dist
      end
    end
    [road.slice(0, index), road.slice(index, road.length - index)]
  end

  def align(geofactory, roads)
    0.upto(roads.size - 2) do |i|
      a, b = roads[i], roads[i+1]
      already_aligned = a.geometry.point_n(a.geometry.points.size - 1) == b.geometry.point_n(0)
      unless already_aligned
        if a.geometry.point_n(0) == b.geometry.point_n(0)
          points = a.geometry.points
          geometry = geofactory.line_string(points)
          roads[i] = RGeo::GeoJSON::Feature.new(geometry)
        else
          points = b.geometry.points
          geometry = geofactory.line_string(points)
          roads[i+1] = RGeo::GeoJSON::Feature.new(geometry)
        end
      end
    end
    roads
  end

  def create_directions(route)
    directions = []
    0.upto(route.size - 2) do |i|
      first = route[i][0]
      second = route[i+1][0]
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