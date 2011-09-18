class CategoriesController < ApplicationController
  resource_controller
  include Aegis::Controller
  permissions :categories, :except => [:index, :change_icon]

  def index
    query = Category.order("french").scoped.from("reports.categories")
    @categories = query.page(page = params[:page] || 1).per(per_page = params[:per_page] || 10)
    flash[:paging] = {page: page, per_page: per_page }
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
