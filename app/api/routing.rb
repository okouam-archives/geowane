class API::Routing < API::Base

  use Rack::JSONP

  before do
    content_type :json
  end

  get '/' do
    route_finder = RouteFinder.new
    start_edge = route_finder.find_closest_edge(params["x1"], params["y1"])
    destination_edge = route_finder.find_closest_edge(params["x2"], params["y2"])
    route = route_finder.find_route(start_edge, destination_edge)
    segments = route.map {|x| RGeo::GeoJSON::Feature.new(x[0])}
    collection = RGeo::GeoJSON::FeatureCollection.new(segments)
    {route: RGeo::GeoJSON.encode(collection), textual: route_finder.create_directions(route)}.to_json

  end

end