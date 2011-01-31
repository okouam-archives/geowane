module Importers

  class GPX

    def create_selection(import, file)
      doc = Nokogiri::XML(File.open(file).readlines.join)
      doc.css("wpt").each do |node|
        content = parse(node)
        next unless is_valid?(content)
        import.selections.build(content)
      end
    end

    def execute(import, selected_items)
      selection = Selection.find(selected_items)
      selection.each {|item| save_location(item, import.id, import.user)}
    end

    private

    def parse(node)
      content = Hash.new
      content[:longitude] = node.attr("lon")
      content[:latitude] = node.attr("lat")
      content[:name] = node.css("name")[0].inner_text
      content[:comment] = node.css("cmt")[0].inner_text if node.css("cmt") && node.css("cmt").size > 0
      content
    end

    def is_valid?(content)
      !content[:name].blank?
    end

    def save_location(selected, import_id, user)
      location = Location.new(longitude: selected.longitude, name: selected.name, user: user, latitude: selected.latitude, long_name: selected.name)
      location.save!
      location.labels.build(key: "IMPORTED FROM", value: import_id, classification: "system", location: location)
      comment_title = "Imported from GPX - CMT node"
      comment_body = selected.comment
      location.comments.build(title: comment_title, comment: comment_body, user: user) if selected.comment
      location.save!
    end

  end

end