class RoadsController < ApplicationController

  def index
    @road_groups = Road.named
  end

end