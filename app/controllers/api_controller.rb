require 'RMagick'

class ApiController < ApplicationController
  caches_page :icon
  skip_before_filter :require_user

  def categories
    if params[:client]
        query = Location
        .scoped
        .select("partner_categories.id, partner_categories.french, partner_categories.icon, count(*) as count")
        .where("partners.name ilike ?", "%#{params[:client]}%")
        .where("NOT categories.is_hidden")
        .group("partner_categories.id, partner_categories.french, partner_categories.icon")
        .order("partner_categories.french ASC")
        .joins(:categories => [:partner_categories => [:partner]])
    else
      query = Category
        .scoped
        .select("categories.id, categories.french, categories.icon, count(*) as count")
        .group("categories.id, categories.french, categories.icon")
        .order("categories.french ASC")
    end
    if params[:country]
      query = query
        .joins(:administrative_unit_0)
        .where("boundaries.name like ?", "%#{params[:country]}%")
    end
    render :json => query.to_json, :callback => params[:callback]
  end

  def features
    query = Location
      .includes(:tags, :administrative_unit_0)
      .where("locations.searchable_name ilike '%#{params[:q]}%'")
      .where("status != 'INVALID'")
      .limit(99)

    if bounds = params[:bounds]
      box = bounds.split(',')
      query =  query.where("ST_Intersects(SetSRID('BOX(#{box[0]} #{box[1]},#{box[2]} #{box[3]})'::box2d::geometry, 4326), locations.feature)")
    end

    results = query.all.to_a

    unless results.size > 98
      query = Road
        .includes(:administrative_unit_0)
        .where("label ilike '%#{params[:q]}%'")
        .limit(99 - results.size)
        .select("id, label, the_geom, country_id, centroid")

      if bounds = params[:bounds]
        box = bounds.split(',')
        query = query.where("ST_Intersects(SetSRID('BOX(#{box[0]} #{box[1]},#{box[2]} #{box[3]})'::box2d::geometry, 4326), roads.centroid)")
      end

      results = results + query.all.to_a
    end

    render :json => results.to_geojson, :callback => params[:callback]
  end

  def route
    @geofactory = RGeo::Geographic.spherical_factory
    route = find_route(params["x1"], params["y1"], params["x2"], params["y2"])
    render :json =>  {route: RGeo::GeoJSON.encode(RGeo::GeoJSON::FeatureCollection.new(route))}.to_json, :callback => params[:callback]
  end

  def location
    id = params[:id]
    render :json => Location.find(id).to_geojson, :callback => params[:callback]
  end

  def locations
    render :json => fetch_locations(params[:bounds], params["classification"], params["name"]), :callback => params[:callback]
  end

  def landmarks
    bbox = params[:bbox]
    visible = []
    params[:visible].split(",").each do |location|
      visible << location
    end
    landmarks = Location.scoped
      .in_bbox(bbox.split(","))
      .joins(:tags => [:category])
      .where("categories.is_landmark")
      .where("NOT categories.is_hidden")
    unless visible.empty?
      landmarks = landmarks.where("locations.id NOT IN  (?)", ([] << visible).flatten)
    end
    render :json => landmarks.to_geojson, :callback => params[:callback]
  end

  private

  def find_route(x1, y1, x2, y2)
    sql = "SELECT * FROM geocms_find_route(#{x1}, #{y1}, #{x2}, #{y2})"
    Road.connection.execute(sql).map do |row|
      geometry = @geofactory.parse_wkt(row["a"])
      feature = RGeo::GeoJSON::Feature.new(geometry, nil, {"label" => row["b"], "start_angle" => row["d"], "end_angle" => row["e"]})
      feature
    end
  end

  def fetch_locations(bounds, classification, name)
    query = Location.valid.includes(:administrative_unit_0, :city).limit(99).in_bbox(bounds.split(","))
    if classification
      query = query
      .joins(:categories => [:partner_categories])
      .where("partner_categories.id = ?", classification)
    elsif name
      query = query.named(name)
    else
      raise "No filtering criteria have been provided"
    end
    query.to_a.to_geojson
  end

end
