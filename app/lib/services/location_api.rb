require 'sinatra/base'
require 'json'
require 'rack/contrib/jsonp'

class Services::LocationApi < Services::Base

  use Rack::JSONP

  before do
    content_type :json
  end

  get '/' do
    sql = %{
      SELECT
        locations.id, longitude, latitude, locations.name,
        cities.name "city", locations.feature, boundaries.name "country"
      FROM locations
        LEFT JOIN cities ON cities.id = locations.city_id
        JOIN boundaries ON boundaries.id = locations.level_0
        JOIN tags ON tags.location_id = locations.id
      WHERE
        status != 'INVALID'
        AND #{build_criteria(params)}
      GROUP BY locations.id, longitude, latitude, locations.name, cities.name, locations.feature, boundaries.name
      LIMIT 99
    }
    Location.find_by_sql(sql).to_a.to_geojson
  end

  private

  def build_criteria(params)
    if params.has_key?("category")
        "tags.category_id = #{params["category"]}"
    elsif params.has_key?("name")
      "locations.name ILIKE '%#{params["name"]}%'"
    else
      raise "No filtering criteria have been provided"
    end
  end

end