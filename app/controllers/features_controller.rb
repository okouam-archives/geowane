class FeaturesController < ApplicationController
  resource_controller

  SRID = Location.geometry_column.srid

  def index
    case params[:source]
      when "search"
        search = Search.find_by_persistence_token(session[:current_search])
        locations = Location.find(search.execute.map{|x| x.id})
      when "selection"
        locations = Location.find(session[:collection], :order => "name")
      else
        raise 'Unknown source'
    end
    render :json => locations.to_geojson
  end

  def show
    location = Location.find(params[:id])
    render :json => [location].to_geojson
  end

  def update

    feature = Geometry.from_geojson(request.raw_post, SRID)

    if feature.nil?
      head :bad_request
      return
    end

    if feature.id.is_a? Integer
      location = Location.find_by_id(feature.id)
    else
      head :not_found
      return
    end

    if location.update_attributes_from_feature(feature)
      render :json => location.to_geojson, :status => :created
    else
      head :unprocessable_entity
    end

  end

  def destroy
    @city = City.find(params[:id])
    @city.destroy
    head :no_content
  end

end