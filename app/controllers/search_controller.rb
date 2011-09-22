class SearchController < ApplicationController
  resource_controller :singleton
  layout "admin"

  new_action.before do
    @all_users = User.dropdown_items
    @all_cities = City.dropdown_items
    @all_level_0 = Boundary.dropdown_items(0)
    @all_categories = Category.dropdown_items
  end

  def lookup
    sql = "SELECT locations.id, locations.name, coalesce(cities.name, '') as city, boundaries.name as country
            FROM locations
            LEFT JOIN cities ON locations.city_id = cities.id
            LEFT JOIN boundaries ON boundaries.id = locations.level_0
            WHERE locations.name ilike '%#{params[:q]}%' LIMIT #{params[:limit]}"
    results = Location.connection.execute(sql)
    render :json => results
end

end
