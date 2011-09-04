class PartnersController < ApplicationController
  resource_controller

  def collection_delete
    Partner.destroy(params[:collection])
    head :ok
  end

  update.wants.html do
    redirect_to edit_partner_path(object)
  end

  create.wants.html do
    redirect_to partners_path
  end

end