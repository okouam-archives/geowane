class City < ActiveRecord::Base
  validates_presence_of :name
  has_many :locations

  def self.dropdown_items
    sql = "SELECT id, name FROM cities ORDER BY name ASC"
    City.connection.select_all(sql).map {|rs| [rs["name"], rs["id"]]}
  end

end