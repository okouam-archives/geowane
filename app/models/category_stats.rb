class CategoryStats

  def self.to_csv

    sql = %{
      SELECT
        category_id as "Identifier",
        name as "Country",
        french as "Category - French",
        english as "Category - English",
        numeric_code as "Garmin Code",
        navteq_french as "NAVTEQ - French",
        navteq_english as "NAVTEQ - English",
        navteq_code as "NAVTEQ Code",
        SUM(CASE WHEN status = 'new' THEN 1 ELSE 0 END) as "New",
        SUM(CASE WHEN status = 'invalid' THEN 1 ELSE 0 END) as "Invalid",
        SUM(CASE WHEN status = 'corrected' THEN 1 ELSE 0 END) as "Corrected",
        SUM(CASE WHEN status = 'audited' THEN 1 ELSE 0 END) as "Audited",
        SUM(CASE WHEN status = 'field_checked' THEN 1 ELSE 0 END) as "Field Checked"
      FROM
        (
        SELECT
          administrative_units.name,
          locations.id,
          locations.status,
          categories.id as category_id,
          categories.french,
          categories.english,
          categories.numeric_code,
          categories.navteq_english,
          categories.navteq_french,
          categories.navteq_code
        FROM
          categories
          JOIN tags on categories.id = tags.category_id
          JOIN locations on locations.id = tags.location_id
          JOIN administrative_units ON locations.level_0 = administrative_units.id
        ORDER BY
          french, administrative_units.name, locations.id
        ) AS overview
      GROUP BY
        name,
        french,
        english,
        numeric_code,
        navteq_french,
        navteq_english,
        navteq_code,
        category_id
    }

    rs = ActiveRecord::Base.connection.execute(sql)

    CSV.generate do |csv|
      csv << ["Identifier", "Country", "Category - French", "Category - English",
              "Garmin Code", "NAVTEQ - French", "NAVTEQ - English", "NAVTEQ Code",
              "New", "Invalid", "Corrected", "Audited", "Field Checked"]
      for record in rs
        csv << record.values.map {|value| value ? value.encode("iso-8859-1") : ""}
      end
    end

  end

end