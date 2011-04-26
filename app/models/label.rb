class Label < ActiveRecord::Base
  belongs_to :location
  validates_presence_of :key, :value, :location
end