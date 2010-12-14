class Shapefile < ActiveRecord::Base
  validates_presence_of :filename

  def count_locations
    self.locations ?  self.locations.split(",").size : 0
  end

end