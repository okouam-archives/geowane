class Navigator

  def initialize
    @geofactory = RGeo::Geographic.spherical_factory
  end

  def find_route(x1, y1, x2, y2)
    sql = "SELECT * FROM find_route(#{x1}, #{y1}, #{x2}, #{y2})"
    Location.connection.execute(sql).map do |x|
      geometry = @geofactory.parse_wkt(x["a"])
      feature = RGeo::GeoJSON::Feature.new(geometry, nil, {"label" => x["b"]})
      feature
    end
  end

end