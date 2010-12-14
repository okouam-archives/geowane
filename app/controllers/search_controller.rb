class SearchController < ApplicationController
  resource_controller
  layout "admin"

  def next
    if session.has_key?(:current_search) || session.has_key?("current_search")
      current_search = session.has_key?(:current_search) ?  session[:current_search] : session["current_search"]
      next_index = current_search.index(params[:id].to_i) + 1
      if next_index > current_search.size - 2
        next_index = 0
      end
      redirect_to edit_location_path(current_search[next_index])
    else
      redirect_to locations_path
    end
  end

end