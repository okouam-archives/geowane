class Level

  def import(shpfile, level_number = nil)

    raise "The file #{shpfile} does not exists." unless File.exists?(shpfile)
    
    @level_number = find_level_number(shpfile) unless level_number   
         
    GeoRuby::Shp4r::ShpFile.open(shpfile) do |shp|
      shp.each do |shape|
        sql = create_sql(shape.geometry, shape.data, shp.fields)
      end
    end
  end

  def create_sql(geometry, data, fields)
    name = data["NAME_FRENC"]
    wkt = geometry.as_wkt
    sql = "INSERT INTO level#{@level_number} (name, feature) VALUES ('#{name}', '#{wkt}')"
    execute(sql)
  end  

  private 

  def self.find_level_number(shpfile)
  end

end
