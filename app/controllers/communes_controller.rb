class CommunesController < ApplicationController
  include Area

  def collection_sql
    "
    SELECT
      countries.name as country,
      regions.name as region,
      cities.name as city,
      communes.id,
      communes.name, count(locations) as locations_count
    FROM communes
      LEFT JOIN locations on ST_Within(locations.feature, communes.feature)
      LEFT JOIN countries on ST_Within(communes.feature, countries.feature)
      LEFT JOIN regions on ST_Within(communes.feature, regions.feature)
      LEFT JOIN cities on ST_Within(communes.feature, cities.feature)
    GROUP BY country, region, city, communes.id, communes.name
    ORDER BY country, region, city, name
    "
  end

end