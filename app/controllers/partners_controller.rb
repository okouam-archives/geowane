class PartnersController < ApplicationController
  resource_controller

  update.wants.html do
    redirect_to edit_partner_path(object)
  end

  create.wants.html do
    redirect_to partners_path
  end

  def edit
    @category = PartnerCategory.new(:partner_id => object.id)
    @classifications = object.categories.map do |taxonomy|
      model = { french: taxonomy.french, english: taxonomy.english }
      model[:icon] = "/images/" + taxonomy.icon if taxonomy.icon
      model[:categories] = taxonomy.mappings.map do |mapping|
        {french: mapping.category.french, delete_link: mapping_path(mapping.id)}
      end
      model
    end
  end

end