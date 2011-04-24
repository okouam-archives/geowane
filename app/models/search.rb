require 'uuidtools'

class Search < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user
  before_save :generate_persistence_token

  def execute
    Location.paginate_by_sql(self.sql, :page => self.page, :per_page => self.per_page)
  end

  def next(id)
    locations, index = current_range_and_index(id)
    new_index = index + 1
    new_index = 0 if new_index >= locations.length
    locations[new_index]
  end

  def previous(id)
    locations, index = current_range_and_index(id)
    new_index = index - 1
    new_index = locations.length - 1 if new_index < 0
    locations[new_index]
  end

  def generate_persistence_token
    self.persistence_token = UUIDTools::UUID.timestamp_create.to_s
  end

  private

  def current_range_and_index(id)
    locations = Location.find_by_sql(sql).map{|l|l.id}
    index = locations.index id.to_i
    return locations, index
  end

end