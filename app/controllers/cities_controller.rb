class CitiesController < ApplicationController
  include Area

  def collection_sql
    "
    SELECT
      countries.name as country,
      regions.name as region, 
      cities.id, 
      cities.name, 
      count(locations.*) as locations_count,
      sum(CASE WHEN category_id IS NULL THEN 0 ELSE 1 END) as categorized_locations,
      sum(CASE WHEN status = 'invalid' THEN 1 ELSE 0 END) as invalid_locations,
      sum(CASE WHEN status = 'new' OR status = 'CORRECTED' THEN 1 ELSE 0 END) as pending_locations,
      sum(CASE WHEN status = 'audited' THEN 1 ELSE 0 END) as audited_locations,
      sum(CASE WHEN status = 'field_checked' THEN 1 ELSE 0 END) as field_checked_locations
    FROM cities
      LEFT JOIN locations on ST_Within(locations.feature, cities.feature)
      LEFT JOIN countries on ST_Within(cities.feature, countries.feature)
      LEFT JOIN regions on ST_Within(cities.feature, regions.feature)
    GROUP BY country, region, cities.id, cities.name
    ORDER BY country, region, name
    "
  end

end
