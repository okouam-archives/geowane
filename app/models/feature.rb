#TO BE REMOVED AND PUT AS AN IMPORTER

require "iconv"

class Feature

  def self.import(directory)
    raise "#{directory} could not be found" unless File.directory?(directory)
    ic = Iconv.new('UTF-8//IGNORE//TRANSLIT', 'ASCII')
    count = 0    
    ["polygon", "point", "line"].each do |shape|
      shpfile = File.join(directory, shape + ".shp")
      raise "{shpfile} could not be found." unless File.exists? shpfile
      GeoRuby::Shp4r::ShpFile.open(shpfile) do |shp|
        shp.each do |feature|
          begin
            count = count + 1
            geom = feature.geometry
            end_level = feature.data["endlevel"] || "null"
            one_way = feature.data["oneway"] == "0" ? false : true
            label = ic.iconv(shape.data["label"]).gsub(/'/, "''") || "null"
            level = feature.data["level"] || "null"
            road_class = feature.data["roadclass"] || "null"
            road_id = feature.data["roadid"] || "null"
            type = feature.data["type"]
            speed = feature.data["speed"] || "null"
            ActiveRecord::Base.connection.execute %{
              INSERT INTO features (end_level, one_way, label, level, road_class, road_id, type, speed, geom)
              VALUES (#{end_level}, #{one_way}, '#{label}', #{level}, #{road_class}, #{road_id}, #{type}, #{speed}, ST_GeomFromText('#{geom.as_wkt}', 4326))
            }
          rescue Exception => e
            puts(e.message)
            puts("Shape Name: #{feature.data["label"]}")
            puts("Shape File: #{shpfile}")
            raise e
          end
        end              
      end
    end
    count
  end

end

