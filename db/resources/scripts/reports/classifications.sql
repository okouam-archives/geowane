CREATE OR REPLACE VIEW reports.classifications AS
      SELECT
        partners.name,
        classifications.id,
        classifications.french,
        classifications.english,
        classifications.icon,
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
        classifications
        JOIN mappings 
	   ON mappings.classification_id = classifications.id
        JOIN tags 
           ON mappings.category_id = tags.category_id
        JOIN
          locations ON locations.id = tags.location_id
        JOIN partners
	  ON partners.id = classifications.partner_id
      GROUP BY
        classifications.id,
        classifications.french,
        classifications.english,
        classifications.icon,
        partners.name;


