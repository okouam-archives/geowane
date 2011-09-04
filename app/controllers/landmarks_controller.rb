class LandmarksController < ApplicationController

  def show
    render :json => Location.find(params[:id]).surrounding_landmarks.to_geojson
  end

end