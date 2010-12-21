require 'enumerated_attribute'

class Import < ActiveRecord::Base
  has_attached_file :input
  belongs_to :user
  validates_presence_of :input_format, :input, :user
  enum_attr :input_format, %w(^GPX SHP)
  has_many :locations

  def execute
    raise 'The imported file must be saved before its data is imported.' unless persisted?
    block = Proc.new do |input_format, input, user, import_id|
      importer = "Import::Importers::#{input_format}".constantize
      importer ? importer.new.execute(input.path, user, import_id) : -1
    end

    self.locations_count = block.call(self.input_format, self.input, self.user, self.id)

  end

  module Importers

    class GPX

      def execute(file, user, import_id)
        locations_count = 0
        doc = Nokogiri::XML(File.open(file).readlines.join)
        doc.css("wpt").each do |node|
          longitude = node.attr("lon")
          latitude = node.attr("lat")
          name = node.css("name")[0].inner_text
          next if name.blank?
          location = Location.new(:longitude => longitude, :name => name, :latitude => latitude, :long_name => name)
          location.feature = Point.from_x_y(longitude, latitude, 4326)
          location.import_id = import_id
          location.user = user
          location.save!
          locations_count += 1
        end
        locations_count
      end

    end

    class SHP

      def execute(file, user)
        raise 'Not implemented yet'
      end
      
    end
    
  end

end
