require 'json'

class LocationResource  < Sinatra::Base

  before do
    content_type :json
  end

  get "/" do
    "Search will go here"
  end

  get "/:id" do
    results = ActiveRecord::Base.connection.execute("SELECT * FROM locations WHERE id = #{params[:id]}")
    results.to_json
  end

  get "/:id/info" do
    results = ActiveRecord::Base.connection.execute("SELECT * FROM locations WHERE id = #{params[:id]}")
    results[0].to_json
  end

  get "/:id/geography" do
    sql = %{
      SELECT
        longitude,
        latitude,
        (select hstore(classification, name) from boundaries where boundaries.id = locations.level_0) as boundary_0,
        (select hstore(classification, name) from boundaries where boundaries.id = locations.level_1) as boundary_1,
        (select hstore(classification, name) from boundaries where boundaries.id = locations.level_2) as boundary_2,
        (select hstore(classification, name) from boundaries where boundaries.id = locations.level_3) as boundary_3,
        (select hstore(classification, name) from boundaries where boundaries.id = locations.level_4) as boundary_4
      FROM
        locations
      WHERE
        locations.id = #{params[:id]}
      }
    ActiveRecord::Base.connection.execute(sql)[0].to_json
  end

  get "/:id/comments" do
    sql = %{
      SELECT
        comment,
        comments.created_at,
        users.login
      FROM comments
      JOIN users
        ON users.id = comments.user_id
      WHERE commentable_id = #{params[:id]}
        AND commentable_type = 'Location'

    }
    ActiveRecord::Base.connection.execute(sql).to_json
  end

  post "/:id/comments" do
    location = Location.find(params[:id])
    post_params = JSON.parse request.body.read
    puts post_params
    location.comments.create!(:comment => post_params[:comment], :user => User.find(post_params[:user_id]))
    latest = location.comments.last
    {comment: latest.comment, created_at: latest.created_at, login: latest.user.login}.to_json
  end

  get "/:id/history" do
    "History of location"
  end

end