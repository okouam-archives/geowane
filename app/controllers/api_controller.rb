require 'RMagick'

class ApiController < ApplicationController
  caches_page :icon
  skip_before_filter :require_user

  def categories
    sql = %{
      SELECT categories.id, french, count(*) as count
      FROM categories
      JOIN tags ON tags.category_id = categories.id
      GROUP BY categories.id, french
      ORDER BY french ASC
    }
    render :json => Category.connection.execute(sql).to_json, :callback => params[:callback]
  end

  def icon
    canvas = Magick::Image.new(24,24) { self.background_color = "#434343" }
    canvas.format = 'gif'
    canvas.border!(1,1,'#fff')
    image = Magick::Draw.new
    image.gravity = Magick::CenterGravity
    image.pointsize = 14
    image.stroke = 'transparent'
    image.fill = '#ffffff'
    image.font_weight = Magick::BoldWeight
    image.font_family = 'Helvetica'
    image.annotate(canvas, 0, 0, 0, 0, params[:num])
    send_data(canvas.to_blob, :type => "image/gif", :disposition => 'inline', :filename => "icon.gif")
  end

  def features
    bounds = params[:bounds].split(',')
    name = params[:q]

    query = Location
      .joins(:tags, :administrative_unit_0)
      .where("locations.name ilike '%#{name}%'")
      .where("ST_Intersects(SetSRID('BOX(#{bounds[0]} #{bounds[1]},#{bounds[2]} #{bounds[3]})'::box2d::geometry, 4326), locations.feature)")
      .where("status != 'INVALID'")
      .limit(99)

    results = query.all.to_a

    unless results.size > 98
      query = Road
        .joins(:administrative_unit_0)
        .where("label ilike '%#{name}%'")
        .where("ST_Intersects(SetSRID('BOX(#{bounds[0]} #{bounds[1]},#{bounds[2]} #{bounds[3]})'::box2d::geometry, 4326), roads.the_geom)")
        .limit(99 - results.size)
        .select("DISTINCT(road_id), label, the_geom, country_id, gid, centroid")
      results = results + query.all.to_a
    end

    render :json => results.to_geojson, :callback => params[:callback]
  end

  def route
    @geofactory = RGeo::Geographic.spherical_factory
    route = find_route(params["x1"], params["y1"], params["x2"], params["y2"])
    render :json =>  {route: RGeo::GeoJSON.encode(RGeo::GeoJSON::FeatureCollection.new(route))}.to_json, :callback => params[:callback]
  end

  def locations
    bounds = params[:bounds].split(',')
    render :json => fetch_locations(bounds, params["category"], params["name"]), :callback => params[:callback]
  end

  private

  def find_route(x1, y1, x2, y2)
    sql = "SELECT * FROM find_route(#{x1}, #{y1}, #{x2}, #{y2})"
    Road.connection.execute(sql).map do |row|
      geometry = @geofactory.parse_wkt(row["a"])
      feature = RGeo::GeoJSON::Feature.new(geometry, nil, {"label" => row["b"], "start_angle" => row["d"], "end_angle" => row["e"]})
      feature
    end
  end

  def fetch_locations(bounds, category, name)
    query = Location
      .joins(:tags, :administrative_unit_0, :city)
      .limit(99)
      .where("ST_Intersects(SetSRID('BOX(#{bounds[0]} #{bounds[1]},#{bounds[2]} #{bounds[3]})'::box2d::geometry, 4326), locations.feature)")
      .where("status != 'INVALID'")
    if category
      query = query.where("tags.category_id = #{category}")
    elsif name
      query = query.where("locations.name ILIKE '%#{name}%'")
    else
      raise "No filtering criteria have been provided"
    end
    query.all.to_a.to_geojson
  end

end