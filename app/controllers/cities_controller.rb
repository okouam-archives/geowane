class CitiesController < ApplicationController
  include Area

  def collection_sql
    "
    SELECT
      countries.name as country,
      regions.name as region, 
      cities.*
    FROM cities
      LEFT JOIN countries on ST_Within(cities.feature, countries.feature)
      LEFT JOIN regions on ST_Within(cities.feature, regions.feature)
    "
  end

end
