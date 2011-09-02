module Geolocatable

  def self.included(base)
    base.validates_presence_of :longitude, :latitude
    base.with_options :class_name => "Boundary" do |entity|
      entity.belongs_to :administrative_unit_0, :foreign_key => "level_0"
      entity.belongs_to :administrative_unit_1, :foreign_key => "level_1"
      entity.belongs_to :administrative_unit_2, :foreign_key => "level_2"
      entity.belongs_to :administrative_unit_3, :foreign_key => "level_3"
      entity.belongs_to :administrative_unit_4, :foreign_key => "level_4"
    end
  end

  def to_geojson(options = nil)
    geoson = { :type => 'Feature' }
    if attributes["feature"]
      factory = RGeo::Geographic.spherical_factory
      geom = factory.point(attributes["feature"].x, attributes["feature"].y)
      geoson[:geometry] = RGeo::GeoJSON.encode(geom)
    end
    geoson[:id] = id
    geoson[:properties] = geojson_attributes
    geoson.to_json
  end

  def administrative_unit(level)
    self.send "administrative_unit_#{level}"
  end

  def longitude=(longitude)
    self[:longitude] = longitude
    update_dynamic_attributes
  end

  def latitude=(latitude)
    self[:latitude] = latitude
    update_dynamic_attributes
  end

  def boundaries
    boundaries = {}
    (0..4).each do |num|
      level = administrative_unit(num)
      boundaries[num.to_s] = {id: level.id, classification: level.classification, name: level.name} if level
    end
    boundaries
  end

  def update_dynamic_attributes
    if self.longitude && self.latitude
      self.feature = GeoRuby::SimpleFeatures::Point.from_x_y(self.longitude, self.latitude, 4326)
      self.administrative_unit_0 = Boundary.find_enclosing(self.longitude, self.latitude, 0)
      self.administrative_unit_1 = Boundary.find_enclosing(self.longitude, self.latitude, 1)
      self.administrative_unit_2 = Boundary.find_enclosing(self.longitude, self.latitude, 2)
      self.administrative_unit_3 = Boundary.find_enclosing(self.longitude, self.latitude, 3)
      self.administrative_unit_4 = Boundary.find_enclosing(self.longitude, self.latitude, 4)
      self.road = Road.closest(self.longitude, self.latitude)
    end
  end

end