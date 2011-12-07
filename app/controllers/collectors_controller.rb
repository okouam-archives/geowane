class CollectorsController < ApplicationController
  resource_controller
  layout "admin"

  def index
    query = User.scoped.select("*").from("reports.collectors")
    query = query.where("login ILIKE ?", "%#{params[:s][:name]}%") if params[:s]
    @collectors = query.paginate(:page => params[:page] || 1, :per_page => params[:per_page] || 10)
  end

end