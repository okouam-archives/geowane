class Country < ActiveRecord::Base
  validates_presence_of :name
  has_many :locations

  def self.dropdown_items
    sql = "SELECT id, name FROM countries ORDER BY name ASC"
    Country.connection.select_all(sql).map {|rs| [rs["name"], rs["id"]]}
  end
  
end