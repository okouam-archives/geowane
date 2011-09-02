class PartnerCategoriesController < ApplicationController
  resource_controller

  create.wants.html do
    redirect_to edit_partner_path(params[:partner_id])
  end

end