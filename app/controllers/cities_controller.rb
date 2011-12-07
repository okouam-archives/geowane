class CitiesController < ApplicationController
  resource_controller

  def index
    session[:city_index_page] = params[:page] || session[:city_index_page]
    session[:city_index_per_page] = params[:per_page] || session[:city_index_per_page] || 10
    @per_page = session[:city_index_per_page]
     @cities = City.from("reports.cities").paginate(:page => params[:page] || 1, :per_page => params[:per_page] || 10)
  end

  create.wants.html do
    redirect_to cities_path
  end

  update.wants.html do
    redirect_to cities_path
  end

  def collection_delete
    City.destroy(params[:collection])
    head :ok
  end

end
