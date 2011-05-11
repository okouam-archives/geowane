class CitiesController < ApplicationController
  include Area

  def index
    session[:city_index_page] = params[:page] || session[:city_index_page]
    session[:city_index_per_page] = params[:per_page] || session[:city_index_per_page] || 10
    @per_page = session[:city_index_per_page]
    sql = "SELECT * from city_workflow_report"
    @cities = Category.find_by_sql(sql).paginate(:page => session[:city_index_page], :per_page => @per_page)
  end

end
