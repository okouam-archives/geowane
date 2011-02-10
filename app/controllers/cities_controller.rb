class CitiesController < ApplicationController
  include Area

  def collection_sql
    "
    SELECT
      cities.id,
      cities.name as name,
      SUM(CASE WHEN status = 'new' THEN 1 ELSE 0 END) as new_locations,
      SUM(CASE WHEN status = 'invalid' THEN 1 ELSE 0 END) as invalid_locations,
      SUM(CASE WHEN status = 'corrected' THEN 1 ELSE 0 END) as corrected_locations,
      SUM(CASE WHEN status = 'audited' THEN 1 ELSE 0 END) as audited_locations,
      SUM(CASE WHEN status = 'field_checked' THEN 1 ELSE 0 END) as field_checked_locations,
      count(categorized) as categorized_locations,
      count(*) as total_locations
    FROM
      locations
      JOIN cities ON locations.city_id = cities.id
      LEFT JOIN (SELECT location_id as categorized FROM tags GROUP BY location_id) t ON t.categorized = locations.id
    GROUP BY
      cities.name, cities.id
    ORDER BY
      cities.name
    "
  end

end
