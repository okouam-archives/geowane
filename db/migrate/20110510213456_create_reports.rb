class CreateReports < ActiveRecord::Migration
  def self.up
    execute %{

      -- CATEGORY WORKFLOW REPORT

      CREATE OR REPLACE VIEW category_workflow_report AS
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

      -- CATEGORY WORKFLOW PARTNER REPORT

      CREATE OR REPLACE VIEW category_workflow_partner_report AS
      SELECT
        overview.category_id AS "Identifier",
        overview.name AS "Country",
        overview.french AS "Category - French",
        overview.english AS "Category - English", overview.numeric_code AS "Garmin Code", overview.navteq_french AS "NAVTEQ - French", overview.navteq_english AS "NAVTEQ - English", overview.navteq_code AS "NAVTEQ Code", sum(
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
   FROM ( SELECT boundaries.name, locations.id, locations.status, categories.id AS category_id, categories.french, categories.english, categories.numeric_code, categories.navteq_english, categories.navteq_french, categories.navteq_code
           FROM categories
      JOIN tags ON categories.id = tags.category_id
   JOIN locations ON locations.id = tags.location_id
   JOIN boundaries ON locations.level_0 = boundaries.id
  ORDER BY categories.french, boundaries.name, locations.id) overview
  GROUP BY overview.name, overview.french, overview.english, overview.numeric_code, overview.navteq_french, overview.navteq_english, overview.navteq_code, overview.category_id;

        -- CITY WORKFLOW REPORT

        CREATE OR REPLACE VIEW city_workflow_report AS
        SELECT cities.id, cities.name, sum(
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
        END) AS field_checked_locations, count(t.categorized) AS categorized_locations, count(locations.id) AS total_locations
       FROM locations
       RIGHT JOIN cities ON locations.city_id = cities.id
       LEFT JOIN ( SELECT tags.location_id AS categorized
          FROM tags
         GROUP BY tags.location_id) t ON t.categorized = locations.id
      GROUP BY cities.name, cities.id
      ORDER BY cities.name;

      -- COLLECTOR WORKFLOW REPORT

      CREATE OR REPLACE VIEW collector_workflow_report AS
       SELECT boundaries.name AS "Country", users.login AS "User", sum(
              CASE
                  WHEN locations.status::text = 'new'::text THEN 1
                  ELSE 0
              END) AS "New", sum(
              CASE
                  WHEN locations.status::text = 'invalid'::text THEN 1
                  ELSE 0
              END) AS "Invalid", sum(
              CASE
                  WHEN locations.status::text = 'corrected'::text THEN 1
                  ELSE 0
              END) AS "Corrected", sum(
              CASE
                  WHEN locations.status::text = 'audited'::text THEN 1
                  ELSE 0
              END) AS "Audited", sum(
              CASE
                  WHEN locations.status::text = 'field_checked'::text THEN 1
                  ELSE 0
              END) AS "Field Checked"
         FROM locations
         JOIN users ON users.id = locations.user_id
         LEFT JOIN boundaries ON locations.level_0 = boundaries.id
        GROUP BY boundaries.name, users.login;

    }
  end

  def self.down
  end
end
