class Location < ActiveRecord::Base
  include Audited
  include Geolocatable
  has_many :photos, :autosave => true, :dependent => :destroy
  acts_as_commentable
  acts_as_audited
  has_one :logo, :autosave => true, :dependent => :destroy
  validates_presence_of :name
  belongs_to :user
  belongs_to :city
  belongs_to :road
  has_many :categories, :through => :tags
  has_many :tags, :autosave => true, :dependent => :destroy
  has_many :labels, :autosave => true, :dependent => :destroy
  has_many :model_changes, :through => :audits

  scope :not_geolocated, lambda {
    where(:level_0 => nil).where(:level_1 => nil).where(:level_2 => nil).where(:level_3 => nil)
  }

  scope :in_boundary, lambda {|level|
    where("level_0 = #{level} OR level_1 = #{level} OR level_2 = #{level} OR level_3 = #{level}")
  }

  scope :in_bbox, lambda {|bbox|
    where("ST_Intersects(SetSRID('BOX(#{bbox[0]} #{bbox[1]},#{bbox[2]} #{bbox[3]})'::box2d::geometry, 4326), locations.feature)")
  }

  scope :labelled, lambda {|key, value, classification|
    joins(:labels)
      .where("labels.classification ilike ?", classification)
      .where("labels.key ilike ?", key.to_s)
      .where("labels.value ilike ?", value.to_s)
  }

  scope :valid, lambda {
    where("status != 'INVALID'")
  }

  scope :field_checked, lambda {
    where("status != 'FIELD_CHECKED'")
  }

  scope :on_street, lambda {|name|
    joins("JOIN roads ON ST_DWithin(locations.feature::geography, roads.the_geom::geography, 100)")
      .where("roads.label ilike ?", "%#{name}%")
  }

  scope :named, lambda {|name| where("locations.name ILIKE '%#{name}%'")}

  enum_attr :status, %w(new invalid corrected audited field_checked), :init => :new, :nil => false

  accepts_nested_attributes_for :tags, :reject_if => lambda { |a| a[:category_id].blank? }

  accepts_nested_attributes_for :comments, :reject_if => lambda { |a| a[:comment].blank? || a[:title].blank? }

  def surrounding_landmarks
    Location.scoped
      .joins(:tags => [:category])
      .where("locations.id != ?", id)
      .where("categories.is_landmark")
      .where("NOT categories.is_hidden")
      .where("ST_DWithin(ST_GeographyFromText('SRID=4326;Point(#{longitude} #{latitude})'), locations.feature::geometry, 500)")
      .order("ST_Distance(ST_GeographyFromText('SRID=4326;Point(#{longitude} #{latitude})'), locations.feature::geometry)")
      .limit(10)
  end

  def geojson_attributes
    attrs = {
      :id => id.to_s,
      :name => name,
      :created_at => created_at.to_s,
      :updated_at => updated_at.to_s,
      :status => status,
      :website => website,
      :acronym => acronym,
      :geographical_address => geographical_address,
      :email => email,
      :opening_hours => opening_hours,
      :telephone => telephone,
      :fax => fax,
      :longitude => longitude.to_s,
      :latitude => latitude.to_s,
      :boundaries => boundaries
    }
    attrs[:photos] = photos.map {|photo| photo.image.url} if photos.size > 0
    attrs[:city_name] = city.name if city
    attrs[:username] = respond_to?(:username) ? username : user.login
    attrs[:icon] = tags.first.category.icon if !tags.empty? && tags.first.category.icon
    attrs
  end

  def to_short_json
    {
      name: name,
      id: id,
      city: city ? city.name : "",
      longitude: longitude,
      latitude: latitude,
      created_at: created_at.strftime("%d-%m-%Y"),
      updated_at: updated_at.strftime("%d-%m-%Y"),
      tags: tags.map {|x| x.category.french}.join(", "),
      added_by: respond_to?(:username) ? username : user.login,
      status: status.to_s.humanize.upcase
    }
  end

end
