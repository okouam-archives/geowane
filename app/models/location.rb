class Location < ActiveRecord::Base
  include Audited
  include Geolocatable
  acts_as_commentable
  acts_as_audited
  validates_presence_of :name
  belongs_to :user
  belongs_to :city

  with_options :autosave => true do |entity|
    entity.has_many :tags
    entity.has_many :labels
  end

  scope :in, lambda {|bounds|
    where("ST_Intersects(SetSRID('BOX(#{bounds[0]} #{bounds[1]},#{bounds[2]} #{bounds[3]})'::box2d::geometry, 4326), locations.feature)")
  }

  scope :valid, where("status != 'INVALID'")

  scope :classified_as, lambda {|classification|
    includes({:tags => {:category => {:mappings => :classification}}}).
      where("classifications.id = #{classification}")
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

end
