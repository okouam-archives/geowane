class CountriesController < ApplicationController
  include Area

  def collection_sql
    "
    SELECT
      countries.id,
      countries.name,
      sum(CASE WHEN tags_count = 0 THEN 0 ELSE 1 END) as categorized_locations,
      sum(CASE WHEN status = 'invalid' THEN 1 ELSE 0 END) as invalid_locations,
      sum(CASE WHEN status = 'new' OR status = 'corrected' THEN 1 ELSE 0 END) as pending_locations,
      sum(CASE WHEN status = 'audited' THEN 1 ELSE 0 END) as audited_locations,
      sum(CASE WHEN status = 'field_checked' THEN 1 ELSE 0 END) as field_checked_locations,
      count(*) as locations_count
    FROM countries
      LEFT JOIN topologies ON topologies.country_id = countries.id
      LEFT JOIN locations ON topologies.location_id = locations.id
    GROUP BY countries.id, countries.name
    ORDER BY name
    "
  end

end
