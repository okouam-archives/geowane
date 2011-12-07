CREATE OR REPLACE VIEW reports.collectors AS
SELECT
  users.login AS login,
  users.id AS user_id,
  sum(CASE WHEN locations.status::text = 'new'::text THEN 1 ELSE 0 END) AS new_locations,
  sum(CASE WHEN locations.status::text = 'invalid'::text THEN 1 ELSE 0  END) AS invalid_locations,
  sum(CASE WHEN locations.status::text = 'corrected'::text THEN 1 ELSE 0 END) AS corrected_locations,
  sum(CASE WHEN locations.status::text = 'audited'::text THEN 1 ELSE 0 END) AS audited_locations,
  sum(CASE WHEN locations.status::text = 'field_checked'::text THEN 1 ELSE 0 END) AS field_checked_locations,
  count(locations.id) AS total_locations,
  count(t.categorized) AS categorized_locations
FROM
  locations
JOIN
  users
    ON users.id = locations.user_id
  LEFT JOIN (SELECT tags.location_id AS categorized FROM tags GROUP BY tags.location_id) t
    ON t.categorized = locations.id
GROUP BY
  users.login, users.id;