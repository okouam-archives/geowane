require 'zlib'
require 'archive/tar/minitar'


class Export < ActiveRecord::Base
  has_attached_file :output
  attr_protected :output_file_name, :output_content_type, :output_size
  enum_attr :output_format, %w(.MP ^.SHP .GPX)
  enum_attr :client, %w(^NAVTEQ)
  belongs_to :user

  def execute(locations)

    statistics = {
      :category_code_missing => [], 
      :city_missing => [], 
      :country_missing => [],
      :region_missing => []
    }      

    shpfile_directory = Tempfile.new(self.name).path 
    File.delete(shpfile_directory)
    Dir.mkdir(shpfile_directory)
    
    shpfile = GeoRuby::Shp4r::ShpFile.create(
      shpfile_directory + "/import", 
      GeoRuby::Shp4r::ShpType::POINT,
      [
        GeoRuby::Shp4r::Dbf::Field.new("FID","C",10),
        GeoRuby::Shp4r::Dbf::Field.new("Type","C",10),
        GeoRuby::Shp4r::Dbf::Field.new("Shape","C",10),
        GeoRuby::Shp4r::Dbf::Field.new("Label","C",200),
        GeoRuby::Shp4r::Dbf::Field.new("Descry","C",200),
        GeoRuby::Shp4r::Dbf::Field.new("City","C",40),
        GeoRuby::Shp4r::Dbf::Field.new("Region","C",40),
        GeoRuby::Shp4r::Dbf::Field.new("Country","C",40),
        GeoRuby::Shp4r::Dbf::Field.new("Highway","C",40),
        GeoRuby::Shp4r::Dbf::Field.new("Level","C",10),
        GeoRuby::Shp4r::Dbf::Field.new("Endlevel","C",10,0)
      ]
    )
    
    shpfile.transaction do |tr|
      locations.each do |l|

        statistics[:category_code_missing] << l unless l.tags.try(:first).try(:category).try(:numeric_code)
        statistics[:region_missing] << l unless l.topology.region
        statistics[:country_missing] << l unless l.topology.country
        statistics[:city_missing] << l unless l.topology.city
        
        new_record = GeoRuby::Shp4r::ShpRecord.new(l.feature,
          'Shape' => 'POINT',
          'FID' => l.id,
          'Type' => l.tags.try(:first).try(:category).try(:numeric_code),
          'Label' => l.name,
          'City' => l.topology.city.try(:name),
          'Region' => l.topology.region.try(:name),
          'Country' => l.topology.country.try(:name),
          'Highway' => "",
          'Level' => l.tags.try(:first).try(:category).try(:level) || 0,
          'Endlevel' => l.tags.try(:first).try(:category).try(:end_level) || 0
        )
        tr.add(new_record)
      end
    end

    shpfile.close

    File.open("import.tar", "wb") do |tar|
      Archive::Tar::Minitar.pack("#{shpfile_directory}", tar)
    end  
       
    File.open("import.tar", 'rb') {|output_file| self.output = output_file} 

    statistics
    
  end

end
