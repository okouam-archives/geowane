require 'uuidtools'

class Search < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user
  before_save :generate_persistence_token
  has_one :criteria, :class_name => "SearchCriteria"

  def self.construct(criteria, sort_order, page, page_size, search_token, user)
    search = Search.new(:user => user, :per_page => page_size || 10, :page => page || 1)
    if criteria && criteria["reset"]
      search.criteria = SearchCriteria.new(Hash.new)
    elsif criteria.nil? && search_token
      search = Search.find_by_persistence_token(search_token)
    else
      # Put sort order back in place at some point
      search.criteria = SearchCriteria.new(criteria)
    end
    search.save!
    search
  end

  def save_to_session(session)
    session[:search_token] = persistence_token
    session[:search_page] = page
    session[:search_page_size] = per_page
  end

  def execute
    query = criteria.create_query.page(self.page).per(self.per_page)
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
    locations = Location.find_by_sql(criteria.create_query.all).map{|l|l.id}
    index = locations.index id.to_i
    return locations, index
  end

end