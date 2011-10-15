class LocationsController < ApplicationController
  include Aegis::Controller
  layout "admin"

  def per_page
    @per_page = params[:per_page] || 10
  end

  def page
    params[:page] || 1
  end

  def index
    search = Search.new(params[:s], params[:sort])
    respond_to do |format|
      format.html do
        @locations = search.execute(page, per_page)
        @sort_params = params.merge({controller: "locations", action: "index"}).except(:page, :per_page)
        @navigation_params =  params.merge({controller: "locations", action: "edit"})
      end
      format.json { render :json => search.execute.to_a.to_geojson }
    end
  end

  def next
    redirect_to edit_location_path(Search.new(params[:s]).next(params[:id]), :page => page, :per_page => per_page)
  end

  def previous
    redirect_to edit_location_path(Search.new(params[:s]).previous(params[:id]), :page => page, :per_page => per_page)
  end

  def collection_delete
    locations = LocationCollection.new(params[:locations])
    locations.destroy_all(current_user)
    redirect_to locations_path
  end

  def collection_edit
    @locations = Location.includes(:comments, :tags, :user).find(params[:locations].split(","), :order => "name")
    respond_to do |format|
      format.json do
        render :json => @locations.to_geojson
      end
      format.html do
        @categories = Category.dropdown_items
        @comments_cache = @locations.map do |loc|
          loc.comments.map {|x| {location_id: x.commentable_id, created_at: x.created_at, text: x.comment, user: x.user.login}}
        end.reject{|x| x.empty?}.flatten.to_json
        @locations_cache = @locations.to_geojson
      end
    end
  end

  def new

  end

  def collection_update
    if params[:commit]
      locations = []
      params[:locations].values.each do |attributes|
        location = Location.find(attributes.delete(:id))
        location.update_attributes!(attributes)
        locations << location
      end
      if request.xhr?
        render :json => locations.to_geojson
      else
        redirect_to locations_path(:page => session[:search_page], :per_page => session[:search_page_size])
      end
    else
      collection = LocationCollection.new(params[:locations])
      render :json => collection.send(params[:call], params[:category]).to_json
    end
  end

  def show
    respond_to do |format|
      format.json do
        @items = Location.find(params[:id].split(","))
        render :json => @items.to_a.to_geojson
      end
    end
  end

  def edit
    @location = Location.find(params[:id])
    @categories = Category.dropdown_items
    @comments = @location.comments.map {|c| c.to_hash}
    @navigation_params =  params.except(:id).merge({controller: "locations", action: "index"})
    @cycling_params =params.merge({controller: "locations"})
  end

  def create
    @categories = Category.dropdown_items
  end

  def update
    location = Location.find(params[:id])
    if location.update_attributes(params[:location])
      render :json => location.to_geojson
    else
      render :text => location.errors
    end
  end
end
