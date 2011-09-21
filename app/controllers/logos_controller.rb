class LogosController < ApplicationController
  resource_controller
  belongs_to :location

  create.wants.html do
    redirect_to edit_location_url(params[:location_id])
  end

end
