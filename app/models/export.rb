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

    shpfile_directory = Tempfile.new(self.name).path
    File.delete(shpfile_directory)
    Dir.mkdir(shpfile_directory)
    
    shpfile = create_shapefile(shpfile_directory)
    
    shpfile.transaction do |tr|

      ic = Iconv.new('LATIN1//TRANSLIT//IGNORE', 'UTF-8')

      locations.each do |l|

        label = l.name
        city = l.city.try(:name)
        level_1 = l.administrative_unit(1).try(:name)
        level_0 = l.administrative_unit(0).try(:name)

        if self.output_platform == :WINDOWS
	        label = to_windows_encoding(ic, label)
          city = to_windows_encoding(ic, l.city.name) if l.city
          level_1 = to_windows_encoding(ic, l.administrative_unit(1).name) if l.administrative_unit(1)
          level_0 = to_windows_encoding(ic, l.administrative_unit(0).name) if l.administrative_unit(0)
        end            

        tr.add(create_shapefile_record(l, label, city, level_1, level_0))
      end
    end

    shpfile.close

    File.open("#{self.name}.tar", "wb") do |tar|
      Archive::Tar::Minitar.pack("#{shpfile_directory}", tar)
    end  
       
    File.open("#{self.name}.tar", 'rb') {|output_file| self.output = output_file}

  end

  private

  def to_windows_encoding(converter, text)
    converter.iconv(text + ' ')[0..-2]
  end

  def create_shapefile(directory)
    GeoRuby::Shp4r::ShpFile.create(directory + "/" + self.name,
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
  end

  def create_shapefile_record(location, label, city, level_1, level_0)
    GeoRuby::Shp4r::ShpRecord.new(location.feature,
      'Shape' => 'POINT',
      'FID' => location.id,
      'Type' => location.tags.try(:first).try(:category).try(:numeric_code),
      'Label' => label,
      'City' => city,
      'Region' => level_1,
      'Country' => level_0,
      'Highway' => "",
      'Description' => location.id,
      'Level' => location.tags.try(:first).try(:category).try(:level) || 0,
      'Endlevel' => location.tags.try(:first).try(:category).try(:end_level) || 0
    )
  end

end
