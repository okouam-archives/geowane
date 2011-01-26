class Commune < ActiveRecord::Base
  validates_presence_of :name
  has_many :locations

  def self.dropdown_items
    sql = "SELECT id, name FROM communes ORDER BY name ASC"
    Commune.connection.select_all(sql).map {|rs| [rs["name"], rs["id"]]}
  end

end