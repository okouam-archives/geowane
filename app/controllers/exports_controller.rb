class ExportsController < ApplicationController
  include Aegis::Controller
  resource_controller

  create.after do
    object.user = current_user
    object.locations_count = session[:locations].size
    object.execute Location.find(session[:locations], :include => [:tags => :category, :topology => [:country, :region, :city]])
    object.save!
  end

  def index
    session[:exports_index_page] = params[:page] || session[:exports_index_page]
    per_page = params[:per_page] || 20
    @exports = Export.all.paginate(:page => session[:exports_index_page], :per_page => per_page)
  end
  
  create.wants.html do
    redirect_to exports_url
  end

  def selection
    @all_countries = Country.connection.select_all("SELECT id, name FROM countries ORDER BY name ASC").map {|rs| [rs["name"], rs["id"]]}
    @all_categories = Category.connection.select_all("SELECT id, french FROM categories ORDER BY french ASC").map {|rs| [rs["french"], rs["id"]]}
    @all_users = User.connection.select_all("SELECT login, id FROM users ORDER BY login ASC").map {|rs| [rs["login"], rs["id"]]}
  end

  def prepare    
    if params[:s]
      countries = params[:s][:country_id].delete_if {|c| c.blank?}
      users = params[:s][:user_id].delete_if {|c| c.blank?}
      categories = params[:s][:category_id].delete_if {|c| c.blank?}
      include_uncategorized = params[:include_uncategorized]
      puts params[:include_uncategorized]
      query = Location.joins(:topology)
      if users.count > 0
        query = query.where("user_id IN (" + users.join(",") + ")")
      end
      if categories.count > 0 || include_uncategorized
        if include_uncategorized.nil? && categories.count > 0
          query = query.where("locations.id IN (SELECT location_id FROM tags WHERE category_id IN (" + categories.join(",") + "))")
        elsif include_uncategorized && categories.count > 0
          query = query.where("locations.id IN (SELECT location_id FROM tags WHERE category_id IN (" + categories.join(",") + ")) OR locations.id NOT IN (SELECT location_id FROM tags)")
        else 
          query = query.where("locations.id NOT IN (SELECT location_id FROM tags)")
        end
      end
      if countries.count > 0
        query = query.where("country_id IN (" + countries.join(",") +")")
      end
      session[:locations] = query.all.map{|c| c.id} 
    else
      session[:locations] = params[:locations]
    end
    redirect_to :action => :new
  end

end
