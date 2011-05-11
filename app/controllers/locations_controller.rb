class LocationsController < ApplicationController
  include Aegis::Controller
  resource_controller
  layout "admin"
  before_filter :assign_form_data, :only => [:create, :edit]

  def index
    debugger
    @search = Search.construct(params[:s], params[:sort], params[:page], params[:per_page], session[:search_token], current_user)
    @search.save_to_session(session)
    respond_to do |format|
      format.html { @locations = @search.execute }
      format.json { render :json => @search.execute.to_a.to_geojson }
    end
  end

  def next
    search = Search.find_by_persistence_token(session[:search_token])
    url = search ? edit_location_path(search.next(params[:id])) : locations_path
    redirect_to url
  end

  def previous
    search = Search.find_by_persistence_token(session[:search_token])
    url = search ? edit_location_path(search.previous(params[:id])) : locations_path
    redirect_to url
  end

  def collection_delete
    locations = LocationCollection.new(params[:locations])
    locations.destroy_all(current_user)
    redirect_to locations_path
  end

  def collection_edit
    if request.post?
      session[:collection] = params[:locations]
      redirect_to "/locations/edit"
    else
      @locations = Location.includes(:comments, :tags, :user).find(session[:collection], :order => "name")
      respond_to do |format|
        format.json do
          render :json => @locations.to_geojson
        end
        format.html do
          @categories = ["", ""] + Category.order("french").map{|c| [c.french, c.id]}
          @comments_cache = @locations.map do |loc|
            loc.comments.map {|x| {location_id: x.commentable_id, created_at: x.created_at, text: x.comment, user: x.user.login}}
          end.reject{|x| x.empty?}.flatten.to_json
          @locations_cache = @locations.map {|location| location.json_object}.to_json
        end
      end
    end
  end

  def collection_update
    if params[:commit]
      params[:locations].values.each do |attributes|
        location = Location.find(attributes.delete(:id))
        location.update_attributes(attributes)
        location.save!
      end
      if request.xhr?
        head :status => 200
      else
        redirect_to "/locations"
      end
    else
      collection = LocationCollection.new(params[:locations])
      render :json => collection.send(params[:call], params[:category]).to_json
    end
  end

  edit.before do
    @categories = ["", ""] + Category.order("french").map{|c| [c.french, c.id]}
    props = [0,1,2,3].inject([]) do |union, n|
      boundary = object.administrative_unit(n)
      boundary ? union << [boundary.classification, boundary.name] : union
    end
    props = props + [["Longitude", object.longitude], ["Latitude", object.latitude]]
    @props = props.to_json
  end

  update do
    wants.html do
      redirect_to edit_location_path(object)
    end
  end

  def assign_form_data
    @form_data = {"categories" => Category.order("french")}
  end

end
