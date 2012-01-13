class LogosController < ApplicationController

  def show
    location = Location.find(params[:location_id])
    if location.logo && location.logo.image && location.logo.image.url
      render :json => {url: location.logo.image.url, id: location.logo.id}
    else
      render :json => {}
    end
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
    location = Location.find(params[:location_id])
    location.logo.destroy
    head :ok
  end

end