class CategoriesController < ApplicationController
  resource_controller
  include Aegis::Controller
  permissions :categories, :except => [:index, :change_icon]

  def index
      session[:category_index_language] = @language = params[:language] || session[:category_index_language] || "french"
      session[:category_index_page] = params[:page] || session[:category_index_page]
      session[:category_index_per_page] = params[:per_page] || session[:category_index_per_page] || 10
      @per_page = session[:category_index_per_page]
      query = Category.scoped.from("reports.categories").order(@language)
      @categories = query.page(session[:category_index_page]).per(@per_page)
  end

  def change_icon
    @icons =  Category.available_icons
  end

  def export
    report_name = "reports.partners"
    send_data Report.new(report_name).to_csv, :filename => "#{report_name}.csv"
  end

  def show
    render :json => object.locations.to_geojson(:only => ["name"])
  end

  create.wants.html do
    redirect_to categories_path
  end

  update.wants.html do
    redirect_to categories_path
  end

end
