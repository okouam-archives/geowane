class Location < ActiveRecord::Base
  include Audited
  include Geolocatable
  acts_as_commentable
  acts_as_audited
  validates_presence_of :name
  belongs_to :user
  belongs_to :city
  has_many :categories, :through => :tags
  has_many :tags, :autosave => true
  has_many :labels, :autosave => true

  scope :not_geolocated, lambda {
    where(:level_0 => nil).where(:level_1 => nil).where(:level_2 => nil).where(:level_3 => nil)
  }

  scope :in_boundary, lambda {|level|
    where("(level_0 = #{level} OR level_1 = #{level} OR level_2 = #{level} OR level_3 = #{level})")
  }

  scope :in_bbox, lambda {|bbox|
    where("ST_Intersects(SetSRID('BOX(#{bbox[0]} #{bbox[1]},#{bbox[2]} #{bbox[3]})'::box2d::geometry, 4326), locations.feature)")
  }

  scope :labelled, lambda {|key, value, classification|
    joins(:labels)
      .where("labels.classification ilike ?", classification)
      .where("labels.key ilike ?", key)
      .where("labels.value = ?", value).count
  }

  scope :valid, lambda {
    where("status != 'INVALID'")
  }

  scope :classified_as, lambda {|classification|
    joins({:tags => {:category => {:mappings => :classification}}}).where("classifications.id = #{classification}")
  }

  scope :named, lambda {|name| where("locations.searchable_name ILIKE '%#{name}%'")}

  enum_attr :status, %w(new invalid corrected audited field_checked), :init => :new, :nil => false

  accepts_nested_attributes_for :tags, :reject_if => lambda { |a| a[:category_id].blank? }

  accepts_nested_attributes_for :comments, :reject_if => lambda { |a| a[:comment].blank? || a[:title].blank? }

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

  def name=(name)
    self[:name] = name
    self.searchable_name = name
  end

end
