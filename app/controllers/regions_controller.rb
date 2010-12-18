class RegionsController < ApplicationController
  include Area

  def collection_sql
    "
    SELECT
        countries.name as country, regions.id, regions.name, count(locations) as locations_count,
        sum(CASE WHEN category_id IS NULL THEN 0 ELSE 1 END) as categorized_locations,
        sum(CASE WHEN status = 'invalid' THEN 1 ELSE 0 END) as invalid_locations,
        sum(CASE WHEN status = 'new' OR status = 'corrected' THEN 1 ELSE 0 END) as pending_locations,
        sum(CASE WHEN status = 'audited' THEN 1 ELSE 0 END) as audited_locations,
        sum(CASE WHEN status = 'field_checked' THEN 1 ELSE 0 END) as field_checked_locations
    FROM regions
      LEFT JOIN locations ON ST_Within(locations.feature, regions.feature)
      LEFT JOIN countries ON ST_Within(regions.feature, countries.feature)
    GROUP BY country, regions.id, regions.name
    ORDER BY country, regions.name
    "
  end

end