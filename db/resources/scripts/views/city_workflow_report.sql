CREATE OR REPLACE VIEW city_workflow_report AS
SELECT
  cities.id,
  cities.name,
  sum(CASE WHEN locations.status::text = 'new' THEN 1 ELSE 0 END) AS new_locations,
  sum(CASE WHEN locations.status::text = 'invalid'::text THEN 1 ELSE 0 END) AS invalid_locations,
  sum(CASE WHEN locations.status::text = 'corrected'::text THEN 1 ELSE 0 END) AS corrected_locations,
  sum(CASE WHEN locations.status::text = 'audited'::text THEN 1  ELSE 0 END) AS audited_locations,
  sum(CASE WHEN locations.status::text = 'field_checked'::text THEN 1 ELSE 0 END) AS field_checked_locations,
  count(t.categorized) AS categorized_locations,
  count(locations.id) AS total_locations
FROM
  locations
  RIGHT JOIN cities
    ON locations.city_id = cities.id
  LEFT JOIN (SELECT tags.location_id AS categorized FROM tags GROUP BY tags.location_id) t
    ON t.categorized = locations.id
GROUP BY
  cities.name,
  cities.id
ORDER BY
  cities.name;