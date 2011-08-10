class CitiesController < ApplicationController

  def index
    session[:city_index_page] = params[:page] || session[:city_index_page]
    session[:city_index_per_page] = params[:per_page] || session[:city_index_per_page] || 10
    @per_page = session[:city_index_per_page]
    sql = "SELECT * from reports.cities"
    @cities = Category.find_by_sql(sql).paginate(:page => session[:city_index_page], :per_page => @per_page)
  end

end
