class PartnersController < ApplicationController
  resource_controller

  update.wants.html do
    redirect_to edit_partner_path(object)
  end

  create.wants.html do
    redirect_to partners_path
  end

  def edit
    sql = "SELECT * FROM reports.classifications WHERE name = '#{object.name}' ORDER BY french"
    @classifications = Classification.find_by_sql(sql)
  end

end