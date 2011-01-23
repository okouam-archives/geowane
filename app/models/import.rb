require 'enumerated_attribute'

class Import < ActiveRecord::Base
  has_attached_file :input
  belongs_to :user
  validates_presence_of :input_format, :input, :user
  enum_attr :input_format, %w(^GPX SHP MP)
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
          content = parse(node)
          next unless is_valid?(content) 
          self.save_location(content, import_id, user)
          locations_count += 1
        end
        locations_count
      end

      def parse(node)
        content = Hash.new
        content[:longitude] = node.attr("lon")
        content[:latitude] = node.attr("lat")
        content[:name] = node.css("name")[0].inner_text
        content[:cmt] = node.css("cmt")[0].inner_text if node.css("cmt") && node.css("cmt").size > 0
        content[:desc] = node.css("desc")[0].inner_text if node.css("desc") && node.css("desc").size > 0
        content[:ele] = node.css("ele")[0].inner_text if node.css("ele") && node.css("ele").size > 0 
        content[:sym] = node.css("sym")[0].inner_text if node.css("sym") && node.css("sym").size > 0
        content 
      end

      def is_valid?(content)
        !content[:name].blank?
      end

      def save_location(content, import_id, user)
        location = Location.new(:longitude => content[:longitude], :name => content[:name], :latitude => content[:latitude], :long_name => content[:name])
        location.feature = Point.from_x_y(content[:longitude].to_f, content[:latitude].to_f, 4326)
        location.import_id = import_id
        location.user = user
        if content[:cmt]
          location.comments.build(:title => "Imported from GPX - CMT node", :comment => "Imported from GPX - CMT node: " + content[:cmt], :user => user)
        end
        location.save!
      end

    end

    class MP

      def execute(file, user, import_id)

        temp_file = File.open(file)
        blocks = []

        while(line = temp_file.readline)
          if line == "" && accumulator != []
            blocks << accumulator
            accumulator = []
            next
          end
        end

        updates = []

        blocks.each do |block|
          unless block.select {|x| x =~ /;FID=/}.empty?
            updates << block
          end
        end

        commands = []

        updates.each do |update|
          command = {}
          command[:id] = update.select {|x| x =~ /;FID=/}.match(/;FID=(\d+)/)[0]
          command[:coordinates] = update.select {|x| x =~ /Data0=/}.match(/;Data0=\((.+)\)/)[0]
          command[:label] = update.select {|x| x =~ /Label=/}.match(/Label=(\d+)/)[0]
          command[:longitude] = command[:coordinates].split(",")[0]
          command[:latitude] = command[:coordinates].split(",")[1]
          commands << command
        end

        commands.each do |command|
          location = Location.find(command[:id])
          location.longitude = command[:longitude]
          location.latitude = command[:latitude]
          location.name = command[:label]
          location.comments.build(:title => "Updated from .MP", :comment => "Updated from .MP")
          location.save!
        end

      end
      
    end
    
  end

end
