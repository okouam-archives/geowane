class PostGIS

  def self.define_function(name)
    path = Rails.root.join("db/resources/scripts/functions/#{name}.sql")
    sql = File.read(path)
    ActiveRecord::Base.connection.execute(sql)
  end

  def self.point(x, y)
    "ST_SetSRID(ST_MakePoint(#{x}, #{y}), 4326)"
  end

  def self.linestring(points)
    points = points.map do |point|
      "#{point[0]} #{point[1]}"
    end
    sql = "ST_GeomFromEWKT('SRID=4269;LINESTRING(#{points.join(",")})')"
  end

end