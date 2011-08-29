class LandmarksController < ApplicationController

  def show
    id = params[:id]

  end

  def index
    @categories = Category
      .where(:is_hidden => false)
      .where(:is_leaf => true)
      .select("id, french, english, is_landmark")
      .order("french")
  end

  def update

  end

end