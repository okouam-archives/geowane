class RegionsController < ApplicationController
  include Area

  def collection_sql
    "
    SELECT
      countries.name as country,
      regions.*
    FROM regions
      LEFT JOIN countries on ST_Within(regions.feature, countries.feature)
    "
  end

end
