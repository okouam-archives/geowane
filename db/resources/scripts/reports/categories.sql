
      CREATE OR REPLACE VIEW reports.categories AS
      SELECT
        categories.id,
        categories.french,
        categories.english,
        categories.icon,
        sum(
          CASE
            WHEN locations.status::text = 'new'::text THEN 1
            ELSE 0
        END) AS new_locations,
        sum(
          CASE
            WHEN locations.status::text = 'invalid'::text THEN 1
            ELSE 0
        END) AS invalid_locations,
        sum(
        CASE
            WHEN locations.status::text = 'corrected'::text THEN 1
            ELSE 0
        END) AS corrected_locations,
        sum(
        CASE
            WHEN locations.status::text = 'audited'::text THEN 1
            ELSE 0
        END) AS audited_locations,
        sum(
        CASE
            WHEN locations.status::text = 'field_checked'::text THEN 1
            ELSE 0
        END) AS field_checked_locations, count(locations.*) AS total_locations
      FROM
        categories
        LEFT JOIN
          tags ON categories.id = tags.category_id
        LEFT JOIN
          locations ON locations.id = tags.location_id
      GROUP BY
        categories.id,
        categories.french,
        categories.english,
        categories.icon;