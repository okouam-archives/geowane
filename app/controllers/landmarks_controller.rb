class LandmarksController < ApplicationController

  def show
    render :json => Location.find(params[:id]).surrounding_landmarks.to_geojson
  end

  def index
    @categories = Category.visible.leaf.select("id, french, english, is_landmark").order("french")
  end

end