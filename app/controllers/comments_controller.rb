class CommentsController < ApplicationController
  resource_controller
  layout nil
  belongs_to :location

  create.before do
    object.user = current_user
  end

  create.wants.html do
    head :ok
  end

end
