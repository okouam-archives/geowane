class SearchController < ApplicationController
  resource_controller :singleton
  layout "admin"

  new_action.before do
    @all_users = User.dropdown_items
    @all_cities = City.dropdown_items
    @all_level_3 = Boundary.dropdown_items(3)
    @all_level_2 = Boundary.dropdown_items(2)
    @all_level_1 = Boundary.dropdown_items(1)
    @all_level_0 = Boundary.dropdown_items(0)
    @all_categories = Category.dropdown_items
  end

  def create
    criteria = params[:search_criteria].delete_if {|key, value| value.blank? || (["category_missing", "category_present"].include?(key) && value == "0")}
    redirect_to locations_path(:s => criteria)
  end

  def lookup
    if query = params[:q]
      sql = "SELECT locations.id, locations.name, coalesce(cities.name, '') as city, boundaries.name as country
              FROM locations
              LEFT JOIN cities ON locations.city_id = cities.id
              LEFT JOIN boundaries ON boundaries.id = locations.level_0
              WHERE searchable_name ilike '%#{query}%' LIMIT 100"
      results = Location.connection.execute(sql)
      render :json => results
    else
      render :lookup
    end
  end

end
