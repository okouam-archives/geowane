class ClassificationsController < ApplicationController
  resource_controller

  def update
    grouping = Classification.find(params[:id])
    grouping.update_attributes(params[:classification])
    grouping.categories.clear
    params[:categories].each {|id| grouping.mappings.create(:category_id => id)}
    redirect_to edit_partner_url(grouping.partner)
  end

  new_action.before do
    @partner = Partner.find(params[:partner_id])
    @object = @partner.classifications.build
    @available = Category.dropdown_items
  end

  edit.before do
    @object = Classification.find(params[:id])
    @selected = @object.categories.map {|category| [category.french, category.id]}
    @available = Category.dropdown_items
  end

  def create
    grouping = Classification.create!(params[:classification], :partner_id => params[:partner_id])
    params[:categories].each {|id| grouping.mappings.create(:category_id => id)}
    redirect_to edit_partner_url(grouping.partner)
  end

  def destroy
    classification = Classification.find(params[:id])
    classification.destroy
    render :nothing => true
  end

end