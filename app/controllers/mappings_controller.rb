class MappingsController < ApplicationController
  resource_controller
  belongs_to :partner_category

  destroy.wants.json  do
    render :json => object
  end


  create.wants.json do
    result = object.attributes
    result[:name] = object.category.french
    result[:partner_id] = object.partner_category.partner.id
    render :json => result
  end

end