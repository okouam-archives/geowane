class API::Routing < API::Base

  use Rack::JSONP

  before do
    content_type :json
  end

  get '/' do
    navigator = Navigator.new
    route = navigator.find_route(params["x1"], params["y1"], params["x2"], params["y2"])
    {route: RGeo::GeoJSON.encode(RGeo::GeoJSON::FeatureCollection.new(route[:segments]))}.to_json
  end

end