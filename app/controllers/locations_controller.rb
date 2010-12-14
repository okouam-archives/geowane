class LocationsController < ApplicationController
  include Aegis::Controller
  resource_controller
  layout "admin"
  before_filter :assign_form_data, :only => [:new, :create, :edit]
  permissions :locations, :except => [:next, :change_search, :change_criteria, :mass_delete, :mass_update, :do_mass_update]

  def index
    page = params[:page]
    @per_page = params[:per_page]
    if params[:s].nil? && session[:current_search]
      page ||= session[:current_search][:page]
      @per_page ||= session[:current_search][:per_page]
      search_query = session[:current_search][:query]
    else
      search_query = Search.create(params[:s], current_user).to_sql
    end
    @per_page ||= 10
    @locations =  Location.find_by_sql(search_query).paginate(:page => page, :per_page => @per_page)
    session[:current_search] = {:query => search_query, :page => page, :per_page => @per_page}
  end

  def change_criteria
    @all_users = User.order("login ASC").map{|user| [user.login, user.id]}
    @all_cities = City.select("id, name").order("name ASC").map{|city| [city.name, city.id]}
    @all_communes = Commune.select("id, name").order("name ASC").map{|commune| [commune.name, commune.id]}
    @all_regions = Region.select("id, name").order("name ASC").map{|region| [region.name, region.id]}
    @all_countries = Country.select("id, name").order("name ASC").map{|country| [country.name, country.id]}
    @all_categories = Category.select("id, french").order("french ASC").map {|category| [category.french, category.id]}
  end

  def next
    current_search = session[:current_search][:query]
    if current_search
      next_location = Search.find_next(current_search, params[:id])
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

  def change_search
    redirect_to :action => :index, :s => params[:s], :per_page => params[:per_page]
  end

  def mass_delete
    locations = Location.find(params[:shapefile][:locations])
    locations.each do |location|
      current_user.may_destroy_location!(location)
      location.destroy
    end
    redirect_to locations_path
  end

  def mass_update
    @locations = Location.find(params[:shapefile][:locations], :order => "name")
    @categories = ["", ""] + Category.order("french").map{|c| [c.french, c.id]}
  end

  def mass_audit
    locations = Location.find(params[:shapefile][:locations])
    locations.each do |location|
      location.status = 'AUDIT'
    end
    redirect_to locations_path
  end

  def do_mass_update
    locations = params["locations"]
    locations.each do |item|
      location = Location.find(item[1][:id])
      current_user.may_update_location!(location)
      location.update_attributes(item[1])
      location.save!
    end
    redirect_to locations_path
  end

  def surrounding_landmarks
    bounds = params[:bounds].map {|corner| corner.to_f}
    all_locations = Location.surrounding_landmarks(object.id, bounds[0], bounds[1], bounds[2], bounds[3], 20)
    render :json => all_locations.map {|feature| feature.json_object}
  end

  show.wants.js do
    render :json => object.json_object
  end

  edit.before do
    object.comments.build
  end

  update do
    wants.html do
      redirect_to edit_location_path(object)
    end
  end

  create.wants.html do
    redirect_to locations_path
  end

  def assign_form_data
    @form_data = {"categories" => Category.order("french")}
  end

end
