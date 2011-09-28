class Road  < ActiveRecord::Base
  belongs_to :category

  scope :closest, lambda {|longitude, latitude|
    where("ST_DWithin(ST_GeographyFromText('SRID=4326;Point(#{longitude} #{latitude})'), roads.the_geom::geography, 500)")
    .order("ST_Distance(ST_GeographyFromText('SRID=4326;Point(#{longitude} #{latitude})'), roads.the_geom::geography)")
    .limit(1)
  }

  scope :named, lambda {
    where("label IS NOT NULL").where("label != ''")
  }

  belongs_to :administrative_unit_0, :foreign_key => "country_id", :class_name => "Boundary"

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
    level = administrative_unit(0)
    {"0" => {id: level.id, classification: level.classification, name: level.name}} if level
  end

end