require 'zlib'
require 'iconv'
require 'archive/tar/minitar'
require 'tmpdir'
require 'fileutils'

class Export < ActiveRecord::Base
  has_attached_file :output
  attr_protected :output_file_name, :output_content_type, :output_size
  enum_attr :output_platform, %w(MAC ^WINDOWS LINUX)
  belongs_to :user

  def execute(locations)
    dir = create_shapefile_directory(self.name)
    dir = create_shapefiles(dir, locations)
    filename = File.join(Dir.tmpdir, "#{self.name}.tar")
    File.open(filename, "wb") {|tar| Archive::Tar::Minitar.pack("#{dir}", tar)}
    File.open(filename, 'rb') {|output_file| self.output = output_file}
  end

  def self.locate(query)

    countries = query["countries"]
    statuses = query[:statuses]
    users = query[:users]
    categories = query[:categories]
    partner_id = query[:partner_id]

    unless statuses || countries || categories || users
      return {locations: [], description: "No filter criteria were selected", partner_id: -1}
    end

    description = ["With partner: #{partner_id}"]
    query = Location.scoped.select("distinct locations.id")

    if statuses
      query = query.where(:status => statuses)
      description << "With statuses: #{statuses}"
    end

    if countries
      query = query.where(:level_0 => countries)
      description << "With countries: #{countries}"
    end

    if users
      query = query.where(:user_id => users)
      description << "With users: #{users}"
    end

    if categories
      query = query.joins(:categories => [:partner_categories]).where("partner_categories.id" => categories)
      description << "With categories: #{categories}"
    end

    {locations: query.map {|l| l.id}, description: description, partner_id: partner_id}

  end

  private

  def create_shapefiles(dir, locations)
    shpfile = create_shapefile(dir)
    shpfile.transaction do |tr|
      locations.each do |location|
        tr.add(create_shapefile_record location)
      end
    end
    shpfile.close
    dir
  end

  def create_shapefile_directory(name)
    dir = File.join(Dir.tmpdir, name)
    FileUtils.rm_rf dir if Dir.exists?(dir)
    Dir.mkdir(dir)
    dir
  end

  def windows_encode(value)
    @iconv ||= Iconv.new('LATIN1//TRANSLIT//IGNORE', 'UTF-8')
    @iconv.iconv(value + ' ')[0..-2]
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
        GeoRuby::Shp4r::Dbf::Field.new("Comment","C",10,0),
        GeoRuby::Shp4r::Dbf::Field.new("Cat_EN","C",200),
        GeoRuby::Shp4r::Dbf::Field.new("Cat_FR","C",200),
        GeoRuby::Shp4r::Dbf::Field.new("Partner","C",200)
      ]
    )
  end

  def on_windows?
    self.output_platform == :WINDOWS
  end

  def create_shapefile_record(location)
    label = location.name
    city = location.city
    region = location.region
    country = location.country
    partner = location.partner
    english_category = location.english_category
    french_category = location.french_category
    if on_windows?
      label = windows_encode(label)
      city = windows_encode(city) if city
      region = windows_encode(region) if region
      country = windows_encode(country) if country
      partner = windows_encode(partner)
    end
    GeoRuby::Shp4r::ShpRecord.new(location.feature,
      'Shape' => 'POINT',
      'FID' => location.id,
      'Type' => location.code,
      'Label' => label,
      'City' => city,
      'Region' => region,
      'Country' => country,
      'Highway' => "",
      'Descry' => location.id,
      'Level' => 0,
      'Endlevel' => 0,
      'Cat_EN' => location.english_category,
      'Cat_FR' => location.french_category,
      'Partner' => partner
    )
  end

end
