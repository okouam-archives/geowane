class Report

  def initialize(view)
    @view = view
  end

  def to_csv
    rs = ActiveRecord::Base.connection.execute("SELECT * FROM #{view}")
    CSV.generate do |csv|
      csv << rs.fields
      for record in rs
        csv << record.values.map {|value| value ? value.encode("iso-8859-1") : ""}
      end
    end
  end

end