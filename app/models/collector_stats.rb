class CollectorStats

    def self.to_csv

    sql = %{
      SELECT
        name as "Country",
        user.login as "User"
        SUM(CASE WHEN status = 'new' THEN 1 ELSE 0 END) as "New",
        SUM(CASE WHEN status = 'invalid' THEN 1 ELSE 0 END) as "Invalid",
        SUM(CASE WHEN status = 'corrected' THEN 1 ELSE 0 END) as "Corrected",
        SUM(CASE WHEN status = 'audited' THEN 1 ELSE 0 END) as "Audited",
        SUM(CASE WHEN status = 'field_checked' THEN 1 ELSE 0 END) as "Field Checked"
      FROM
        locations
        JOIN users ON users.id = locations.user_id
        LEFT JOIN administrative_units ON locations.level_0 = administrative_units.id
      GROUP BY
        name, 
        user.login
    }

    rs = ActiveRecord::Base.connection.execute(sql)

    CSV.generate do |csv|
      csv << ["Country", "User", "New", "Invalid", "Corrected", "Audited", "Field Checked"]
      for record in rs
        csv << record.values.map {|value| value ? value.encode("iso-8859-1") : ""}
      end
    end

    end

end