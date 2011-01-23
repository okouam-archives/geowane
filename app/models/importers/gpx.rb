module Importers

  class GPX

    def insert(file, user, import_id)
      counter = 0
      doc = Nokogiri::XML(File.open(file).readlines.join)
      doc.css("wpt").each do |node|
        content = parse(node)
        next unless is_valid?(content)
        self.save_location(content, import_id, user)
        counter += 1
      end
      counter
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

end