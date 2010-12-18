class TagsController < ApplicationController
  resource_controller
  belongs_to :location
  layout :nil

  create.wants.html do
    head :ok
  end

end