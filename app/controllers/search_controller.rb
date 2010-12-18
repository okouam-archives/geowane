class SearchController < ApplicationController
  resource_controller :singleton
  layout "admin"

  new_action.before do
    @all_users = User.order("login ASC").map{|user| [user.login, user.id]}
    @all_cities = City.select("id, name").order("name ASC").map{|city| [city.name, city.id]}
    @all_communes = Commune.select("id, name").order("name ASC").map{|commune| [commune.name, commune.id]}
    @all_regions = Region.select("id, name").order("name ASC").map{|region| [region.name, region.id]}
    @all_countries = Country.select("id, name").order("name ASC").map{|country| [country.name, country.id]}
    @all_categories = Category.select("id, french").order("french ASC").map {|category| [category.french, category.id]}
  end

  def create
    redirect_to locations_path(:s => params[:search])
  end

end