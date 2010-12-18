class CategoriesController < ApplicationController
  resource_controller
  include Aegis::Controller
  permissions :categories, :except => [:index, :change_icon]

  def index
    session[:category_index_language] = @language = params[:language] || session[:category_index_language] || "french"
    session[:category_index_page] = params[:page] || session[:category_index_page]
    per_page = params[:per_page] || 20
    sql = %{
      SELECT categories.id, categories.french, categories.english, icon,
        count(*) as locations_count,
        sum(CASE WHEN status = 'new' THEN 1 ELSE 0 END) as new_locations,
        sum(CASE WHEN status = 'corrected' THEN 1 ELSE 0 END) as corrected_locations,
        sum(CASE WHEN status = 'invalid' THEN 1 ELSE 0 END) as invalid_locations,
        sum(CASE WHEN status = 'audited' THEN 1 ELSE 0 END) as audited_locations,
        sum(CASE WHEN status = 'field_checked' THEN 1 ELSE 0 END) as field_checked_locations
      FROM categories LEFT JOIN locations on locations.category_id = categories.id
      GROUP BY categories.id, categories.french, categories.english, icon
      ORDER BY #{@language}
    }
    @categories = Category.find_by_sql(sql).paginate(:page => session[:category_index_page], :per_page => per_page)
  end

  def save_icon
    object.icon = params[:filename]
    object.save
    redirect_to edit_object_path(object)
  end

  def change_icon
    @icons =  Dir[File.expand_path(File.join(Rails.root,'public/images/google/*'))].map {|file| file.gsub("#{Rails.root}/public/images/", "")}
  end

  def locations
    bounds = params[:bounds].map {|corner| corner.to_f}
    all_locations = Location.within_bounds_for_category(params[:id], bounds[0], bounds[1], bounds[2], bounds[3])
    subset = all_locations.paginate(:page => 1, :per_page => 20)
    render :json =>{:categories => subset.map{|location| location.json_object}, "total_entries" => subset.total_entries}
  end

  create.wants.html do
    redirect_to categories_path
  end

  update.wants.html do
    redirect_to categories_path
  end

end