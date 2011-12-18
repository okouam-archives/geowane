class LocationResource  < Sinatra::Base

  get "/" do
    "Search will go here"
  end

  get "/:id" do
    sql = %{
      SELECT name, email, telephone, fax, website, postal_address, opening_hours, user_rating
    }
    results = ActiveRecord::Base.connection.execute("SELECT * FROM locations WHERE id = #{params[:id]}")
    results.to_json
  end

  get "/:id/coordinates" do
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
    ActiveRecord::Base.connection.execute(sql).to_json
  end

  get "/:id/comments" do
    "Commensdfsdfsdfts for location"
  end

  get "/:id/history" do
    "History of location"
  end

end