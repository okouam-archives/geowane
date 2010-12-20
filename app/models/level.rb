class Level

  def import(shpfile, table_name)

    raise "The file #{shpfile} does not exists." unless File.exists?(shpfile)
         
    GeoRuby::Shp4r::ShpFile.open(shpfile) do |shp|
      shp.each do |shape|
        sql = create_sql(shape.geometry, shape.data, table_name) 
      end
    end
  end

  def create_sql(geometry, data, table_name)
    name = data["NAME_FRENC"]
    wkt = geometry.as_wkt
    sql = "INSERT INTO #{table_name} (name, feature) VALUES ('#{name}', '#{wkt}')"
    ActiveRecord::Base.execute(sql)
  end 

end
