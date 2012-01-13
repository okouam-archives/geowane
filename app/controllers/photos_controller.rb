class PhotosController < ApplicationController

  def show
    sql = %{
      SELECT
        id, '/system/uploads/photos/' || image as url
      FROM
        photos
      WHERE
        location_id = #{params[:location_id]}
        AND image is not null
    }
    render :json => ActiveRecord::Base.connection.execute(sql)
  end

  def create
    location = Location.find(params[:location_id])
    photo = location.photos.build
    photo.image = params[:photo][:image]
    if photo.save
      render :json => {success: true, url: photo.image.url, id: photo.id}
    else
      render :status => :bad_request
    end
  end

  def delete
    sql = %{
      DELETE FROM photos WHERE id = #{params[:id]} AND location_id = #{params[:location_id]}
    }
    ActiveRecord::Base.connection.execute(sql)
    head :ok
  end

end