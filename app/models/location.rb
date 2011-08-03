require 'nokogiri'
require 'will_paginate'

class Location < ActiveRecord::Base
  include Audited
  acts_as_commentable
  acts_as_audited
  validates_presence_of :longitude, :latitude, :name
  belongs_to :user
  belongs_to :city

  with_options :class_name => "Boundary" do |entity|
    entity.belongs_to :administrative_unit_0, :foreign_key => "level_0"
    entity.belongs_to :administrative_unit_1, :foreign_key => "level_1"
    entity.belongs_to :administrative_unit_2, :foreign_key => "level_2"
    entity.belongs_to :administrative_unit_3, :foreign_key => "level_3"
  end
  with_options :autosave => true do |entity|
    entity.has_many :tags
    entity.has_many :labels
  end
  enum_attr :status, %w(new invalid corrected audited field_checked), :init => :new, :nil => false
  accepts_nested_attributes_for :tags, :reject_if => lambda { |a| a[:category_id].blank? }
  accepts_nested_attributes_for :comments, :reject_if => lambda { |a| a[:comment].blank? || a[:title].blank? }

  scope :within_bounds_for_category, lambda {|category_id, top, left, right, bottom|
    {:conditions => ["feature && SetSrid('BOX3D(? ?, ? ?)'::box3d, 4326) and category_id = #{category_id}", top, left, right, bottom]}
  }

  scope :surrounding_landmarks, lambda {|location_id, top, left, right, bottom, limit|
    {:conditions => ["categories.icon is not null AND feature && SetSrid('BOX3D(? ?, ? ?)'::box3d, 4326) AND locations.id != ?", top, left, right, bottom, location_id],
     :joins => "join categories on categories.id = locations.category_id", :limit => limit,
     :select => "locations.*"}
  }


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
    (0..3).each do |num|
      level = administrative_unit(num)
      boundaries[num.to_s] = {id: level.id, classification: level.classification, name: level.name} if level
    end
    boundaries
  end

  private

  def geojson_attributes
    attrs = {
      :id => id.to_s,
      :name => name,
      :created_at => created_at.to_s,
      :updated_at => updated_at.to_s,
      :status => status,
      :website => website,
      :email => email,
      :opening_hours => opening_hours,
      :telephone => telephone,
      :fax => fax,
      :longitude => longitude.to_s,
      :latitude => latitude.to_s,
      :boundaries => boundaries
    }
    attrs[:city_name] = city.name if city
    attrs[:username] = respond_to?(:username) ? username : user.login
    attrs[:icon] = tags.first.category.icon if !tags.empty? && tags.first.category.icon
    attrs
  end

  def update_dynamic_attributes
    if self.longitude && self.latitude
      self.feature = GeoRuby::SimpleFeatures::Point.from_x_y(self.longitude, self.latitude, 4326)
      self.administrative_unit_0 = Boundary.find_enclosing(self.longitude, self.latitude, 0)
      self.administrative_unit_1 = Boundary.find_enclosing(self.longitude, self.latitude, 1)
      self.administrative_unit_2 = Boundary.find_enclosing(self.longitude, self.latitude, 2)
      self.administrative_unit_3 = Boundary.find_enclosing(self.longitude, self.latitude, 3)
    end
  end

end
