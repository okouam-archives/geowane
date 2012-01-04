class LogosController < ApplicationController

  def show
    id = params[:location_id]
  end

  def create
    location = Location.find(params[:location_id])
    logo = location.build_logo
    logo.image = params[:photo][:image]
    if logo.save
      render :json => {success: true, url: logo.image.url}
    else
      render :text => 'error'
    end
  end

  def delete
    id = params[:id]
  end

end