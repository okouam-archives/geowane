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

  def collection_create
    locations = params[:locations]
    if locations.nil? || locations.size < 1
      head :bad_request
      return
    end
    comment = params[:comment]
    if comment.nil? || comment.size < 1
      head :bad_request
      return
    end
    locations = Location.find(locations)
    comments = locations.map do |location|
      location.comments.create!(:comment => comment, :user => current_user)
    end

    render :json => comments.map {|x| {text: x.comment, created_at: x.created_at, location_id: x.commentable_id, user: x.user.login}}
  end

end
