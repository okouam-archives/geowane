require 'enumerated_attribute'

class Import < ActiveRecord::Base
  has_attached_file :input
  belongs_to :user
  validates_presence_of :input_format, :input, :user
  enum_attr :input_format, %w(^GPX SHP)

  def execute

    block = Proc.new do |input_format, input, user|
      importer = "Importers::#{input_format}".constantize
      importer ? importer.new.execute(input, user) : -1
    end

    self.locations_count = block.call(self.input_format, self.input, self.user)

  end

  module Importers

    class GPX

      def execute(file, user)
        locations_count = 0
        doc = Nokogiri::XML(file)
        doc.css("wpt").each do |node|
          longitude = node.attr("lon")
          latitude = node.attr("lat")
          name = node.css("name")[0].inner_text
          next if name.blank?
          location = Location.new(:longitude => longitude, :name => name, :latitude => latitude, :long_name => name)
          location.feature = Point.from_x_y(longitude, latitude, 4326)
          location.user = self.user
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