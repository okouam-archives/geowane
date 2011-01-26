require 'zlib'
require 'archive/tar/minitar'


class Export < ActiveRecord::Base
  has_attached_file :output
  attr_protected :output_file_name, :output_content_type, :output_size
  enum_attr :output_format, %w(.MP ^.SHP .GPX)
  enum_attr :output_platform, %w(MAC ^WINDOWS LINUX)
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
      shpfile_directory + "/" + self.name, 
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
        GeoRuby::Shp4r::Dbf::Field.new("Endlevel","C",10),
        GeoRuby::Shp4r::Dbf::Field.new("Comment","C",10,0)
      ]
    )
    
    ic = Iconv.new('LATIN1//TRANSLIT//IGNORE', 'UTF-8')
    
    shpfile.transaction do |tr|
      locations.each do |l|

        statistics[:category_code_missing] << l unless l.tags.try(:first).try(:category).try(:numeric_code)
        statistics[:region_missing] << l unless l.topology.region
        statistics[:country_missing] << l unless l.topology.country
        statistics[:city_missing] << l unless l.topology.city

        label = l.name
        city = l.topology.city
        region = l.topology.region
        country = l.topology.country

        if self.output_platform == :WINDOWS
	        label = ic.iconv(label + ' ')[0..-2]
          city = ic.iconv(l.topology.city.name + ' ')[0..-2] if l.topology.city
          region = ic.iconv(l.topology.region.name + ' ')[0..-2] if l.topology.region
          country = ic.iconv(l.topology.country.name + ' ')[0..-2] if l.topology.country
        end            
        
        new_record = GeoRuby::Shp4r::ShpRecord.new(l.feature,
          'Shape' => 'POINT',
          'FID' => l.id,
          'Type' => l.tags.try(:first).try(:category).try(:numeric_code),
          'Label' => label,
          'City' => city,
          'Region' => region,
          'Country' => country,
          'Highway' => "",
          'Description' => l.id,
          'Level' => l.tags.try(:first).try(:category).try(:level) || 0,
          'Endlevel' => l.tags.try(:first).try(:category).try(:end_level) || 0
        )
        tr.add(new_record)
      end
    end

    shpfile.close

    File.open("#{self.name}.tar", "wb") do |tar|
      Archive::Tar::Minitar.pack("#{shpfile_directory}", tar)
    end  
       
    File.open("#{self.name}.tar", 'rb') {|output_file| self.output = output_file}

    statistics
    
  end

end
