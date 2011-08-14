CREATE OR REPLACE VIEW reports.partners AS
      SELECT
        overview.category_id AS "Identifier",
        overview.name AS "Country",
        overview.french AS "Category - French",
        overview.english AS "Category - English",
        sum(
        CASE
            WHEN overview.status::text = 'new'::text THEN 1
            ELSE 0
        END) AS "New", sum(
        CASE
            WHEN overview.status::text = 'invalid'::text THEN 1
            ELSE 0
        END) AS "Invalid", sum(
        CASE
            WHEN overview.status::text = 'corrected'::text THEN 1
            ELSE 0
        END) AS "Corrected", sum(
        CASE
            WHEN overview.status::text = 'audited'::text THEN 1
            ELSE 0
        END) AS "Audited", sum(
        CASE
            WHEN overview.status::text = 'field_checked'::text THEN 1
            ELSE 0
        END) AS "Field Checked"
   FROM ( SELECT boundaries.name, locations.id, locations.status, categories.id AS category_id, categories.french, categories.english
           FROM categories
      JOIN tags ON categories.id = tags.category_id
   JOIN locations ON locations.id = tags.location_id
   JOIN boundaries ON locations.level_0 = boundaries.id
  ORDER BY categories.french, boundaries.name, locations.id) overview
  GROUP BY overview.name, overview.french, overview.english, overview.category_id;
