class Region < ActiveRecord::Base
  validates_presence_of :name, :feature

  def self.dropdown_items
    sql = "SELECT id, name FROM regions ORDER BY name ASC"
    Region.connection.select_all(sql).map {|rs| [rs["name"], rs["id"]]}
  end

end