
CREATE OR REPLACE VIEW reports.boundaries_0 AS
 SELECT level_0.name AS level_0, level_0.id AS level_0_id, sum(
        CASE
            WHEN locations.status::text = 'new'::text THEN 1
            ELSE 0
        END) AS new_locations, sum(
        CASE
            WHEN locations.status::text = 'invalid'::text THEN 1
            ELSE 0
        END) AS invalid_locations, sum(
        CASE
            WHEN locations.status::text = 'corrected'::text THEN 1
            ELSE 0
        END) AS corrected_locations, sum(
        CASE
            WHEN locations.status::text = 'audited'::text THEN 1
            ELSE 0
        END) AS audited_locations, sum(
        CASE
            WHEN locations.status::text = 'field_checked'::text THEN 1
            ELSE 0
        END) AS field_checked_locations, sum(
        CASE
            WHEN l.my_tags_count < 1 THEN 1
            ELSE 0
        END) AS uncategorized_locations, count(*) AS total_locations
   FROM locations
   JOIN ( SELECT locations.id, count(DISTINCT tags.category_id) AS my_tags_count
           FROM locations
      LEFT JOIN tags ON tags.location_id = locations.id
     GROUP BY locations.id) l ON locations.id = l.id
   LEFT JOIN boundaries level_0 ON locations.level_0 = level_0.id
  GROUP BY level_0.name, level_0.id
  ORDER BY level_0.name;