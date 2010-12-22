require 'zlib'
require 'archive/tar/minitar'


class Export < ActiveRecord::Base
  has_attached_file :output
  attr_protected :output_file_name, :output_content_type, :output_size
  enum_attr :output_format, %w(.MP ^.SHP .GPX)
  belongs_to :user

  def execute(locations)

    shpfile_path = Tempfile.new(self.name).path
    shpfile = GeoRuby::Shp4r::ShpFile.create(
      shpfile_path, 
      GeoRuby::Shp4r::ShpType::POINT,
      [
        GeoRuby::Shp4r::Dbf::Field.new("Hoyoyo","C",10),
        GeoRuby::Shp4r::Dbf::Field.new("Boyoul","N",10,0)
      ]
    )

    shpfile.transaction do |tr|
      locations.each do |l|
        new_record = GeoRuby::Shp4r::ShpRecord.new(l.feature,
          'Hoyoyo' => "AEZ",
          'Bouyoul' => 45
        )
        tr.add(new_record)
      end
    end

    shpfile.close

    puts shpfile_path 
    
    tgz = Zlib::GzipWriter.new(File.open(Tempfile.new(self.name).path, 'wb'))

    puts tgz.path

    Archive::Tar::Minitar.pack("#{shpfile.path}", tgz)
    output_file_path = tgz.path
    tgz.close
    
    File.open(output_file_path, 'rb') {|output_file| self.output = output_file}
    
  end

end
