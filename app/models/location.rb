require 'nokogiri'
require 'will_paginate'

class Location < ActiveRecord::Base
  include Audited
  acts_as_commentable
  acts_as_audited
  accepts_nested_attributes_for :comments, :reject_if => lambda { |a| a[:comment].blank? || a[:title].blank? }

  validates_presence_of :longitude, :latitude, :name
  belongs_to :user
  has_many :tags, :autosave => true
  enum_attr :status, %w(new invalid corrected audited field_checked), :init => :new, :nil => false
  accepts_nested_attributes_for :tags, :reject_if => lambda { |a| a[:category_id].blank? }

  scope :within_bounds_for_category, lambda {|category_id, top, left, right, bottom|
    {:conditions => ["feature && SetSrid('BOX3D(? ?, ? ?)'::box3d, 4326) and category_id = #{category_id}", top, left, right, bottom]}
  }

  scope :surrounding_landmarks, lambda {|location_id, top, left, right, bottom, limit|
    {:conditions => ["categories.icon is not null AND feature && SetSrid('BOX3D(? ?, ? ?)'::box3d, 4326) AND locations.id != ?", top, left, right, bottom, location_id],
     :joins => "join categories on categories.id = locations.category_id", :limit => limit,
     :select => "locations.*"}
  }

  def city
    return nil unless self.longitude && self.latitude
    City.find_by_sql("select * from cities WHERE ST_WITHIN(setsrid(ST_Point(#{self.longitude}, #{self.latitude}), 4326), cities.feature)").first
  end

  def commune
    return nil unless self.longitude && self.latitude
    Commune.find_by_sql("select * from communes where ST_WITHIN(setsrid(ST_Point(#{self.longitude}, #{self.latitude}), 4326), communes.feature)").first
  end

  def region
    return nil unless self.longitude && self.latitude
    Region.find_by_sql("select * from regions WHERE ST_WITHIN(setsrid(ST_Point(#{self.longitude}, #{self.latitude}), 4326), regions.feature)").first
  end

  def country
    return nil unless self.longitude && self.latitude
    Country.find_by_sql("select * from countries WHERE ST_WITHIN(setsrid(ST_Point(#{self.longitude}, #{self.latitude}), 4326), countries.feature)").first
  end

  def country_name
    return nil unless self.longitude && self.latitude  
    resultset = Location.connection.select_all("SELECT name FROM countries JOIN topologies ON topologies.country_id = countries.id AND topologies.location_id = #{self.id}")
    resultset[0] ? resultset[0]["name"]: nil 
  end

  def region_name
    return nil unless self.longitude && self.latitude  
    resultset = Location.connection.select_all("SELECT name FROM regions JOIN topologies ON topologies.region_id = regions.id AND topologies.location_id = #{self.id}")
    resultset[0] ? resultset[0]["name"]: nil 
  end

  def commune_name
    return nil unless self.longitude && self.latitude  
    resultset = Location.connection.select_all("SELECT name FROM communes JOIN topologies ON topologies.commune_id = communes.id AND topologies.location_id = #{self.id}")
    resultset[0] ? resultset[0]["name"]: nil 
  end

  def city_name
    return nil unless self.longitude && self.latitude  
    resultset = Location.connection.select_all("SELECT name FROM cities JOIN topologies ON topologies.city_id = cities.id AND topologies.location_id = #{self.id}")
    resultset[0] ? resultset[0]["name"] : nil
  end

  def json_object
    { :label => name,
      :id => id,
      :name => name,
      :longitude => longitude,
      :latitude => latitude,
      :icon => !tags.empty? && tags.first.category.icon ? tags.first.category.icon : nil,
      :commune => commune_name,
      :country => country_name,
      :city => city_name,
      :region => region_name,
      :feature => feature.as_wkt
    }
  end

  def category
    categories.empty? ? nil : categories.first
  end  

  def longitude=(longitude)
    self[:longitude] = longitude
    update_dynamic_attributes
  end

  def latitude=(latitude)
    self[:latitude] = latitude
    update_dynamic_attributes
  end

  private

  def update_dynamic_attributes
    if self.longitude && self.latitude
      self.feature = GeoRuby::SimpleFeatures::Point.from_x_y(self.longitude, self.latitude, 4326)
    end
  end

end
