class CitiesController < ApplicationController

  def index
    session[:city_index_page] = params[:page] || session[:city_index_page]
    session[:city_index_per_page] = params[:per_page] || session[:city_index_per_page] || 10
    @per_page = session[:city_index_per_page]
    @cities = City.from("reports.cities").page(session[:city_index_page]).per(@per_page)
  end

end
