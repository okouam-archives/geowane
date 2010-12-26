class TagsController < ApplicationController
  resource_controller
  belongs_to :location
  layout :nil

  create.wants.html do
    head :ok
  end

  def index
    location_id = params[:location_id]
    sql = "SELECT tags.id, categories.french FROM categories JOIN tags ON categories.id = tags.category_id WHERE tags.location_id = #{location_id} ORDER BY tags.id ASC"
    rs = Comment.connection.select_all(sql)
    @collection = rs.map do |row|
      {:name => row["french"], :delete_link => location_tag_url(location_id, row["id"])}  
    end
  end

end
