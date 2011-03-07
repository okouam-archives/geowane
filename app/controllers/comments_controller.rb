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
    render :json => {created_at: object.created_at, location_id: object.commentable_id, text: object.comment, user: current_user.login}
  end

end
