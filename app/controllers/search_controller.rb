class SearchController < ApplicationController
  resource_controller :singleton
  layout "admin"

  new_action.before do
    @all_users = User.dropdown_items
    @all_cities = City.dropdown_items
    @all_communes = Commune.dropdown_items
    @all_regions = Region.dropdown_items
    @all_countries = Country.dropdown_items
    @all_categories = Category.dropdown_items
  end

  def create
    criteria = params[:search].delete_if {|key, value| value.blank? || (["category_missing", "category_present"].include?(key) && value == "0")}
    redirect_to locations_path(:s => criteria)
  end

end
