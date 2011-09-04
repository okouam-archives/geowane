class PartnerCategoriesController < ApplicationController
  resource_controller
  belongs_to :partners

  def collection_delete
    PartnerCategory.destroy(params[:collection])
    head :ok
  end

  create.wants.html do
    redirect_to edit_partner_path(params[:partner_id])
  end

  def edit
    @object = Partner.find(params[:partner_id]).partner_categories.find(params[:id])
  end

  def index
    @categories = Partner.find(params[:partner_id]).partner_categories
    respond_to do |format|
      format.json {render :json => @categories}
    end
  end

  def update
    category = Partner.find(params[:partner_id]).partner_categories.find(params[:id])
    category.update_attributes(params[:partner_category])
    category.save!
    redirect_to edit_partner_path(params[:partner_id])
  end

  def new
    @object = Partner.find(params[:partner_id]).partner_categories.build
  end

  def create
    Partner.find(params[:partner_id]).partner_categories.new(params[:partner_category]).save!
    redirect_to edit_partner_path(params[:partner_id])
  end

end