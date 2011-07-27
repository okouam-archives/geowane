class BoundariesController < ApplicationController

  def index
    @depth = params[:depth].to_i
    sql = "SELECT * FROM reports.boundaries_#{@depth}"
    @collection = Boundary.find_by_sql(sql)
  end

end