class Search

  def initialize(query)
    @criteria = SearchCriteria.new(query)
  end

  def execute(page, per_page)
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
        array_to_string(array(select categories.french from categories join tags on categories.id = tags.category_id and tags.location_id = pois.id), ', ') as tag_list,
        (select name from boundaries where boundaries.id = pois.level_0) as boundary_0,
        (select name from boundaries where boundaries.id = pois.level_1) as boundary_1,
        (select name from boundaries where boundaries.id = pois.level_2) as boundary_2,
        (select name from boundaries where boundaries.id = pois.level_3) as boundary_3,
        (select name from boundaries where boundaries.id = pois.level_4) as boundary_4,
        (select count(*) from comments where commentable_id = pois.id and commentable_type = 'Location') as num_comments
      FROM
        locations as pois
      WHERE
        EXISTS (#{@criteria.create_query.to_sql} AND pois.id = locations.id)
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
    locations = connection.select_values(@criteria.create_query.select("locations.id").to_sql)
    index = locations.index id
    return locations, index
  end

end