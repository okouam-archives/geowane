class BoundariesController < ApplicationController

  def index
    @depth = params[:depth].to_i
    respond_to do |format|
      format.html do
        sql = "SELECT * FROM reports.boundaries_#{@depth}"
        @collection = Boundary.find_by_sql(sql)
      end
      format.json do
        boundarys
        render :json => Boundary.scoped.where(:level => @depth)
      end
    end

  end

  def show
    boundary = Boundary.find(params[:id])
    respond_to do |format|
      format.json do
        render :json => boundary.children.map {|child| {id: child.id, name: child.name, classification: child.classification}}.to_json
      end
    end
  end

end