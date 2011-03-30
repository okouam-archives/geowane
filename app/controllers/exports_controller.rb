class ExportsController < ApplicationController
  include Aegis::Controller
  resource_controller

  create.after do
    object.user = current_user
    object.locations_count = session[:locations].size
    object.execute Location.find(session[:locations], :include => [:city, :tags => :category])
    object.save!
  end

  def index
    session[:exports_index_page] = params[:page] || session[:exports_index_page]
    @per_page = params[:per_page] || 10
    @exports = Export.order("created_at desc").paginate(:page => session[:exports_index_page], :per_page => @per_page)
  end
  
  create.wants.html do
    redirect_to exports_url
  end

  def selection
    @all_countries = Boundary.dropdown_items(0)
    @all_categories = Category.dropdown_items
    @all_users = User.dropdown_items
    @all_statuses = Location.new.enums(:status).select_options
  end

  def prepare    
    if params[:s]
      countries = params[:s][:country_id].delete_if {|c| c.blank?}
      statuses = params[:s][:status].delete_if {|c| c.blank?}
      users = params[:s][:user_id].delete_if {|c| c.blank?}
      categories = params[:s][:category_id].delete_if {|c| c.blank?}
      include_uncategorized = params[:include_uncategorized]
      query = Location.where("user_id IN (" + users.join(",") + ")") if users.count > 0
      if categories.count > 0 || include_uncategorized
        if include_uncategorized.nil? && categories.count > 0
          query = query.where("locations.id IN (SELECT location_id FROM tags WHERE category_id IN (" + categories.join(",") + "))")
        elsif include_uncategorized && categories.count > 0
          query = query.where("locations.id IN (SELECT location_id FROM tags WHERE category_id IN (" + categories.join(",") + ")) OR locations.id NOT IN (SELECT location_id FROM tags)")
        else 
          query = query.where("locations.id NOT IN (SELECT location_id FROM tags)")
        end
      end
      query = query.where("status IN ('" + statuses.join("','") +"')")
      query = query.where("level_0 IN (" + countries.join(",") +")") if countries.count > 0
      session[:locations] = query.all.map{|c| c.id}
    else
      session[:locations] = params[:locations]
    end
    redirect_to :action => :new
  end

end
