class SearchController < ApplicationController
  resource_controller :singleton
  layout "admin"

  new_action.before do
    @all_users = User.dropdown_items
    @all_cities = City.dropdown_items
    @all_administrative_units_0 = AdministrativeUnit.select("id, name").where("depth = 0").order("name")
    @all_administrative_units_1 = AdministrativeUnit.select("id, name").where("depth = 1").order("name")
    @all_administrative_units_2 = AdministrativeUnit.select("id, name").where("depth = 2").order("name")
    @all_administrative_units_3 = AdministrativeUnit.select("id, name").where("depth = 3").order("name")
    @all_administrative_units_4 = AdministrativeUnit.select("id, name").where("depth = 4").order("name")
    @all_categories = Category.dropdown_items
  end

  def create
    criteria = params[:search].delete_if {|key, value| value.blank? || (["category_missing", "category_present"].include?(key) && value == "0")}
    redirect_to locations_path(:s => criteria)
  end

end
