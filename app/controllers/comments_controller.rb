class CommentsController < ApplicationController

  def show
    sql = %{
      SELECT
        comment,
        comments.created_at,
        users.login
      FROM comments
      JOIN users
        ON users.id = comments.user_id
      WHERE commentable_id = #{params[:location_id]}
        AND commentable_type = 'Location'

    }
    render :json => ActiveRecord::Base.connection.execute(sql)
  end

  def create
    sql = %{
      INSERT INTO comments (comment, user_id, commentable_type, commentable_id)
      VALUES ('#{params[:comment]}', #{current_user.id}, 'Location', #{params[:location_id]}
        AND commentable_type = 'Location'

    }
    ActiveRecord::Base.connection.execute(sql)
    render :json => {comment: params[:comment], created_at: DateTime.now, login: current_user.login}.to_json
  end

end
