class LandmarksController < ApplicationController

  def show
    bbox = params[:bbox]
    visible = []
    params[:visible].split(",").each do |location|
      visible << location
    end
    landmarks = Location.scoped
      .in_bbox(bbox.split(","))
      .joins(:tags => [:category])
      .where("locations.id != ?", visible)
      .where("categories.is_landmark")
      .where("NOT categories.is_hidden")
    render :json => landmarks.to_geojson
  end

end