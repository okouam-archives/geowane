class Search

  def initialize(query, sort_order = nil)
    @criteria = SearchCriteria.new(query)
    @sort_order = sort_order || "pois.name"
  end

  def execute(page = nil, per_page = nil)
    sql = %{
      SELECT
      id, city_id,
      longitude,
      latitude,
      pois.name,
      long_name,
      status,
      pois.updated_at,
      pois.created_at,
      (select users.login from users where users.id = pois.user_id) as username,
      (select cities.name from cities where cities.id = pois.city_id) as city_name,
      array_to_string(array(select categories.french from categories join tags on categories.id = tags.category_id and tags.location_id = pois.id), ', ') as tag_list
      FROM
      locations as pois
      WHERE
      EXISTS (#{@criteria.create_query.to_sql} AND pois.id = locations.id)
      ORDER BY #{@sort_order}
      }
    query = @criteria.create_query
    total_entries = query.count()
    Location.paginate_by_sql sql, {:page => page, :per_page => per_page, :total_entries => total_entries}
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

  private

  def current_range_and_index(id)
    connection = ActiveRecord::Base.connection
    sql = %{
      SELECT
      id,
      pois.name,
      status,
      pois.updated_at,
      pois.created_at,
      (select users.login from users where users.id = pois.user_id) as username,
      (select cities.name from cities where cities.id = pois.city_id) as city_name
      FROM
      locations as pois
      WHERE
      EXISTS (#{@criteria.create_query.to_sql} AND pois.id = locations.id)
      ORDER BY #{@sort_order}
      }
    locations = connection.select_values(sql)
    puts locations
    index = locations.index id
    return locations, index
  end

end