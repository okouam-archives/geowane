require 'nokogiri'
require 'will_paginate'

class Location < ActiveRecord::Base
  include Audited
  acts_as_commentable
  acts_as_audited
  validates_presence_of :longitude, :latitude, :name
  belongs_to :user
  with_options :class_name => "AdministrativeUnit" do |entity|
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

  def city
    return nil unless self.longitude && self.latitude
    City.find_by_sql("select * from cities WHERE ST_WITHIN(setsrid(ST_Point(#{self.longitude}, #{self.latitude}), 4326), cities.feature)").first
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
      :commune => administrative_unit(3).try(:name),
      :country => administrative_unit(0).try(:name),
      :city => administrative_unit(2).try(:name),
      :region => administrative_unit(1).try(:name),
      :feature => feature.as_wkt
    }
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

  private

  def update_dynamic_attributes
    if self.longitude && self.latitude
      self.feature = GeoRuby::SimpleFeatures::Point.from_x_y(self.longitude, self.latitude, 4326)
      self.administrative_unit_0 = AdministrativeUnit.find_enclosing(self.longitude, self.latitude, 0)
      self.administrative_unit_1 = AdministrativeUnit.find_enclosing(self.longitude, self.latitude, 1)
      self.administrative_unit_2 = AdministrativeUnit.find_enclosing(self.longitude, self.latitude, 2)
      self.administrative_unit_3 = AdministrativeUnit.find_enclosing(self.longitude, self.latitude, 3)
    end
  end

end
