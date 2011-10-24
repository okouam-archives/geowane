class LogosController < ApplicationController

  def create
    object.logo = Logo.new(params[:logo])
    object.logo.save!
    respond_to do |format|
      format.html do
        redirect_to edit_location_url(object.id)
      end
    end
  end

  def destroy
    location = Location.find(params[:location_id])
    location.logo.destroy
    redirect_to edit_location_url(object.id)
  end

  def object
    Location.find(params[:location_id])
  end

end