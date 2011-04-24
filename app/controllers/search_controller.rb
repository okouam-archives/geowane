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

end
