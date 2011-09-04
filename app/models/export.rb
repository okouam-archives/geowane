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
    countries = query[:country_id].reject{|x| x.blank?}
    statuses = query[:status].reject{|x| x.blank?}
    users = query[:user_id].reject{|x| x.blank?}
    categories = query[:category_id].reject{|x| x.blank?}
    include_uncategorized = query[:include_uncategorized]
    query = Location.scoped.select("id")
    return query.where("1 = 2") if statuses.empty? && countries.empty? && categories.empty? && users.empty? && !include_uncategorized
    query = query.where(:status => statuses) if statuses.size > 0
    query = query.where(:level_0 => countries) if countries.size > 0
    query = query.where(:user_id => users) if users.size > 0
    filter_categories(query, categories, include_uncategorized, client)
  end

  private

  def self.filter_categories(query, categories, include_uncategorized, client)
    if categories.any? || include_uncategorized
      if include_uncategorized.nil? && categories.any?
        query = query.where(%{
          locations.id IN
          (
            SELECT location_id
            FROM tags
            JOIN categories ON tags.category_id = categories.id
            JOIN mappings ON mappings.category_id = categories.id
            JOIN partner_categories ON mappings.partner_category_id = partner_categories.id
            WHERE partner_categories.id IN (#{categories.join(",")})
          )
        })
      elsif include_uncategorized && categories.any?
        query = query.where(%{
          locations.id IN
          (
            SELECT location_id
            FROM tags
            JOIN categories ON tags.category_id = categories.id
            JOIN mappings ON mappings.category_id = categories.id
            JOIN partner_categories ON mappings.partner_category_id = partner_categories.id
            WHERE partner_categories.id IN (#{categories.join(",")})
          )
          OR locations.id NOT IN (SELECT location_id FROM tags)
        })
      else
        query = query.where("locations.id NOT IN (SELECT id FROM tags)")
      end
    end
    query
  end

  def create_shapefiles(dir, locations)
    shpfile = create_shapefile(dir)
    shpfile.transaction do |tr|
      locations.each do |l|
        label = l.name
        city = l.city.try(:name)
        level_1 = l.administrative_unit(1).try(:name)
        level_0 = l.administrative_unit(0).try(:name)
        if self.output_platform == :WINDOWS
          label = windows_encode(label)
          city = windows_encode(city) if l.city
          level_1 = windows_encode(level_1) if level_1
          level_0 = windows_encode(level_0) if level_0
        end
        tr.add(create_shapefile_record(l, label, city, level_1, level_0))
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

        GeoRuby::Shp4r::Dbf::Field.new("NAVTEQ_ENG","C",200),
        GeoRuby::Shp4r::Dbf::Field.new("NAVTEQ_COD","C",200),
        GeoRuby::Shp4r::Dbf::Field.new("SYGIC_ENG","C",200),
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
      'Descry' => location.id,
      'Level' => 0,
      'Endlevel' => 0,
      'NAVTEQ_ENG' => location.tags.try(:first).try(:category).try(:navteq_english),
      'NAVTEQ_COD' => location.tags.try(:first).try(:category).try(:navteq_code),
      'SYGIC_ENG' => location.tags.try(:first).try(:category).try(:sygic_english)
    )
  end

end
