class PartnersController < ApplicationController
  resource_controller

  update.wants.html do
    redirect_to edit_partner_path(object)
  end

  create.wants.html do
    redirect_to partners_path
  end

end