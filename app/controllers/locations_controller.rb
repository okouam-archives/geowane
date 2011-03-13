class LocationsController < ApplicationController
  include Aegis::Controller
  resource_controller
  layout "admin"
  before_filter :assign_form_data, :only => [:create, :edit]

  def index
    page = params[:page]
    @per_page = params[:per_page]
    if params[:s].nil? && session[:current_search]
      page ||= session[:current_search][:page]
      @per_page ||= session[:current_search][:per_page]
      search_query = session[:current_search][:query]
    else
      if params[:s].is_a?(Hash)
        search_query = Search.create params[:s], params[:sort]
      else
        search_query = Search.create nil, params[:sort]
      end
    end
    @per_page ||= 10
    @locations =  Location.paginate_by_sql(search_query, :page => page, :per_page => @per_page)
    session[:current_search] = {:query => search_query, :page => page, :per_page => @per_page}
  end

  def next
    current_search = session[:current_search]
    query = current_search ? current_search[:query] : nil
    if query
      next_location = Search.find_next(query, params[:id])
      redirect_to edit_location_path(next_location)
    else
      redirect_to locations_path
    end
  end

  def previous
    current_search = session[:current_search][:query]
    if current_search
      previous_location = Search.find_previous(current_search, params[:id])
      redirect_to edit_location_path(previous_location)
    else
      redirect_to locations_path
    end
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
      @categories = ["", ""] + Category.order("french").map{|c| [c.french, c.id]}
      @comments_cache = @locations.map do |loc|
        loc.comments.map {|x| {location_id: x.commentable_id, created_at: x.created_at, text: x.comment, user: x.user.login}}
      end.reject{|x| x.empty?}.flatten.to_json
      @locations_cache = @locations.map {|location| location.json_object}.to_json
    end
  end

  def collection_update
    if params[:commit]
      params[:locations].values.each do |attributes|
        location = Location.find(attributes.delete(:id))
        location.update_attributes(attributes)
        location.save!
      end
      redirect_to "/locations"
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
  end

  show.wants.js do
    render :json => object.json_object
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
