class ConversionsController < ApplicationController
  resource_controller

  create.after do
    object.execute
    object.save!
  end

  create.wants.html do
    redirect_to conversions_url
  end

end