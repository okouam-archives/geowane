class LocationsController < ApplicationController
  include Aegis::Controller
  resource_controller
  layout "admin"
  before_filter :assign_form_data, :only => [:create, :edit]
  respond_to :html, :json

  def index
    search = nil
    page = params[:page]
    @per_page = params[:per_page]
    if params[:s].nil? && session[:current_search]
      search = Search.find_by_persistence_token(session[:current_search])
      page ||= search.page
      @per_page ||= search.per_page
      sql = search.sql
    else
      criteria = params[:s].is_a?(Hash) ? params[:s] : nil
      sql = SearchCriteria.create_sql criteria, params[:sort]
    end
    @per_page ||= 10

    search ||= Search.new(:user => current_user)
    search.update_attributes(:user => current_user, :sql => sql, :page => page, :per_page => @per_page)
    search.save!

    session[:current_search] = search.persistence_token

    respond_to do |format|
      format.html do
        @locations = search.execute
      end
      format.json do
        render :json => search.execute.to_a.to_geojson
      end
    end

  end

  def next
    search = Search.find_by_persistence_token(session[:current_search])
    url = search ? edit_location_path(search.next(params[:id])) : locations_path
    redirect_to url
  end

  def previous
    search = Search.find_by_persistence_token(session[:current_search])
    url = search ? edit_location_path(search.previous(params[:id])) : locations_path
    redirect_to url
  end

  def collection_delete
    locations = Location.find(params[:locations])
    locations.each do |location|
      current_user.may_destroy_location!(location)
      location.destroy
    end
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

  def surrounding_landmarks
    bounds = params[:bounds].map {|corner| corner.to_f}
    all_locations = Location.surrounding_landmarks(object.id, bounds[0], bounds[1], bounds[2], bounds[3], 20)
    render :json => all_locations.map {|feature| feature.json_object}
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

  create.after do
    object.user_id = current_user
    object.save!
  end

  create.wants.html do
    redirect_to locations_path
  end

  def assign_form_data
    @form_data = {"categories" => Category.order("french")}
  end

end
