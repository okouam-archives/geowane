class SearchController < ApplicationController
  resource_controller :singleton
  layout "admin"

  new_action.before do
    @all_users = User.connection.select_all("SELECT login, id FROM users ORDER BY login ASC").
                        map {|rs| [rs["login"], rs["id"]]}
    @all_cities = City.connection.select_all("SELECT id, name FROM cities ORDER BY name ASC").
                        map {|rs| [rs["name"], rs["id"]]}
    @all_communes = Commune.connection.select_all("SELECT id, name FROM communes ORDER BY name ASC").
                        map {|rs| [rs["name"], rs["id"]]}
    @all_regions = Region.connection.select_all("SELECT id, name FROM regions ORDER BY name ASC").
                        map {|rs| [rs["name"], rs["id"]]}
    @all_countries = Country.connection.select_all("SELECT id, name FROM countries ORDER BY name ASC").
                        map {|rs| [rs["name"], rs["id"]]}
    @all_categories = Category.connection.select_all("SELECT id, french FROM categories ORDER BY french ASC").
                        map {|rs| [rs["french"], rs["id"]]}
  end

  def create
    criteria = params[:search].delete_if {|key, value| value.blank? || (["category_missing", "category_present"].include?(key) && value == "0")}
    redirect_to locations_path(:s => criteria)
  end

end
