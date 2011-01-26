class Selection < ActiveRecord::Base
  belongs_to :import
  belongs_to :original, :class_name => "Location"
  validates_presence_of :longitude, :latitude, :name
end