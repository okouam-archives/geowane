class CountersController < ApplicationController
  resource_controller
  layout "admin"

  def index
    @counters = User.select("*").from("reports.collectors").paginate(:page => params[:page] || 1, :per_page => params[:per_page] || 10)
  end

end