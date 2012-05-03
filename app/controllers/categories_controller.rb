class CategoriesController < ApplicationController
  resource_controller
  include Aegis::Controller
  permissions :categories, :except => [:index]

  def index
    query = Category.scoped.from("reports.categories")
    query = query.where("french ILIKE ? OR english ILIKE ?", "%#{params[:s][:name]}%", "%#{params[:s][:name]}%") if params[:s]
    @categories = query.paginate(:page => params[:page] || 1, :per_page => params[:per_page] || 10)
  end

  def show
    render :json => object.locations.to_geojson(:only => ["name"])
  end


  def edit
    @category = Category.find(params[:id])
    render :layout => false
  end

  create.wants.html do
    redirect_to categories_path
  end

  update.wants.html do
    redirect_to categories_path
  end

end
