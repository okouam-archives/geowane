class CountriesController < ApplicationController
  include Area

  def collection_sql
    "
    SELECT
      * 
    FROM 
      countries
    "
  end

end
