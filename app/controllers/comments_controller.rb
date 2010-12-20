class CommentsController < ApplicationController
  resource_controller
  layout nil
  belongs_to :location

  index.wants.html do
    @show_facebox_actions = true if params[:layout] && params[:layout] == "facebox"
  end

  create.before do
    object.user = current_user
  end

  create.wants.html do
    head :ok
  end

end
