class City < ActiveRecord::Base
  validates_presence_of :name
  has_many :locations

  def self.dropdown_items
    connection = ActiveRecord::Base.connection
    connection.select_rows("SELECT name, id FROM cities ORDER BY name ASC")
  end

end