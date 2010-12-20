class RegionsController < ApplicationController
  include Area

  def collection_sql
    "
    SELECT
        countries.name as country, regions.id, regions.name, count(*) as locations_count,
        sum(CASE WHEN tags_count = 0 THEN 0 ELSE 1 END) as categorized_locations,
        sum(CASE WHEN status = 'invalid' THEN 1 ELSE 0 END) as invalid_locations,
        sum(CASE WHEN status = 'new' OR status = 'corrected' THEN 1 ELSE 0 END) as pending_locations,
        sum(CASE WHEN status = 'audited' THEN 1 ELSE 0 END) as audited_locations,
        sum(CASE WHEN status = 'field_checked' THEN 1 ELSE 0 END) as field_checked_locations
    FROM regions
      LEFT JOIN topologies ON topologies.region_id = regions.id
      LEFT JOIN locations ON topologies.location_id = locations.id
      LEFT JOIN countries ON topologies.country_id = countries.id
    GROUP BY country, regions.id, regions.name
    ORDER BY country, regions.name
    "
  end

end
