class Road  < ActiveRecord::Base
  set_primary_key :gid

  scope :closest, lambda {|longitude, latitude|
    where("ST_DWithin(ST_GeographyFromText('SRID=4326;Point(#{longitude} #{latitude})'), locations.the_geom::geometry, 500)")
    .order("ST_Distance(ST_GeographyFromText('SRID=4326;Point(#{longitude} #{latitude})'), locations.the_geom::geometry)")
    .limit(1)
  }

  with_options :class_name => "Boundary" do |entity|
    entity.belongs_to :administrative_unit_0, :foreign_key => "country_id"
  end

  def to_geojson(options = nil)
    geoson = { :type => 'Feature' }
    if attributes["centroid"]
      factory = RGeo::Geographic.spherical_factory
      geom = factory.point(attributes["centroid"].x, attributes["centroid"].y)
      geoson[:geometry] = RGeo::GeoJSON.encode(geom)
    end
    geoson[:id] = id
    geoson[:properties] = geojson_attributes
    geoson.to_json
  end

  def geojson_attributes
    attrs = {
      :id => id.to_s,
      :name => label,
      :boundaries => boundaries
    }
    attrs
  end

  def administrative_unit(level)
    self.send "administrative_unit_#{level}"
  end

  def boundaries
    boundaries = {}
    [0].each do |num|
      level = administrative_unit(num)
      boundaries[num.to_s] = {id: level.id, classification: level.classification, name: level.name} if level
    end
    boundaries
  end

end