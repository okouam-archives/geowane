class Partner < ActiveRecord::Base
  has_many :classifications

  def self.dropdown_items
    sql = "SELECT id, name FROM partners ORDER BY name ASC"
    Partner.connection.select_all(sql).map {|rs| [rs["name"], rs["id"]]}
  end

end