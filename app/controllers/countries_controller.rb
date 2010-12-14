class CountriesController < ApplicationController
  include Area

  def collection_sql
    "
    SELECT
      countries.id,
      countries.name,
      sum(CASE WHEN category_id IS NULL THEN 0 ELSE 1 END) as categorized_locations,
      sum(CASE WHEN status = 'INVALID' THEN 1 ELSE 0 END) as invalid_locations,
      sum(CASE WHEN status = 'NEW' OR status = 'CORRECTED' THEN 1 ELSE 0 END) as pending_locations,
      sum(CASE WHEN status = 'AUDITED' THEN 1 ELSE 0 END) as audited_locations,
      sum(CASE WHEN status = 'FIELD CHECKED' THEN 1 ELSE 0 END) as field_checked_locations,
      count(locations) as locations_count
    FROM countries
      LEFT JOIN locations ON ST_Within(locations.feature, countries.feature)
    GROUP BY countries.id, countries.name
    ORDER BY name
    "
  end

end