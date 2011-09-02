class ExportsController < ApplicationController
  include Aegis::Controller
  resource_controller

  PAGER = :exports_index_page

  create.after do
    object.user = current_user
    object.locations_count = session[:locations].size
    object.execute Location.find(session[:locations], :include => [:city, :tags => :category])
    object.output_format = ".SHP"
    object.save!
  end

  def index
    session[PAGER] = params[:page] || session[PAGER]
    @per_page = params[:per_page] || 10
    @exports = Export.order("created_at desc").page(session[PAGER]).per(@per_page)
  end
  
  create.wants.html do
    redirect_to exports_url
  end

  def selection
    @all_countries = Boundary.dropdown_items(0)
    @all_categories = Category.dropdown_items
    @all_users = User.dropdown_items
    @all_statuses = Location.new.enums(:status).select_options
    @all_partners = ["0-One"]+ Partner.dropdown_items
  end

  def count
    render :json => Export.locate(params[:s]).count
  end

  def prepare
    session[:locations] =  params[:s] ? Export.locate(params[:s]).all.map{|c| c.id} : params[:locations]
    redirect_to :action => :new
  end

end
