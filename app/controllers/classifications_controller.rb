class ClassificationsController < ApplicationController
  resource_controller

  new_action.before do
    @partner = Partner.find(params[:partner_id])
    @object = @partner.classifications.build
  end

  def create
    @classification = Classification.new(params[:classification])
    @classification.partner = Partner.find(params[:partner_id])
    @classification.save!
    categories = params[:categories]
    categories.each do |category|
      @classification.mappings.build(:category_id => category)
    end
    @classification.save!
    redirect_to edit_partner_url(Partner.find(params[:partner_id]))
  end

end