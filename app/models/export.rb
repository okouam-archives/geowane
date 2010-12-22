class Export < ActiveRecord::Base
  has_attached_file :output
  attr_protected :output_file_name, :output_content_type, :output_size
  enum_attr :output_format, %w(.MP ^.SHP .GPX)
  belongs_to :user

  def execute(locations)

    shpfile = ShpFile.create(
      Tempfile.new(self.name).path, 
      ShpType::POINT,
      [
        Dbf::Field.new("Hoyoyo","C",10),
        Dbf::Field.new("Boyoul","N",10,0)
      ]
    )

    shpfile.transaction do |tr|
      locations.each do |l|
        new_record = ShpRecord.new(l.feature,
          'Hoyoyo' => "AEZ",
          'Bouyoul' => 45
        )
        tr.add(new_record)
      end
    end

    shpfile.close

    tgz = Zlib::GzipWriter.new(File.open(Tempfile.new(self.name).path, 'wb'))
    Minitar.pack('shpfile.path', tgz)

    File.open(tgz.path, 'rb') {|output_file| self.output = output_file}

  end

end
