module Importers

  class MP

    def create_selection(import, file)
      commands = parse(file)
      locations = Location.find(commands.map{|x| x[:id]})
      lookup = Hash.new
      locations.each {|loc| lookup[loc.id] = loc}
      commands.each do |command|
        id = command[:id]
        if location = lookup[id.to_i]
          command[:selection][:original] = location
          import.selections.build(command[:selection])
        end
      end
    end

    def execute(import, selected_items)
      selection = Selection.find(selected_items)
      selection.each do |item|
        item.original.longitude = item.longitude
        item.original.latitude = item.latitude
        item.original.name = item.original.long_name = item.name
        item.original.comments.build(title: "Updated from .MP", comment: "Updated from .MP", user: import.user)
        item.original.save!
      end
    end

    private

    def parse(file)
      features = identify_features(File.open(file))
      updates = isolate_updates(features)
      updates.map {|update| create_selectable_item(update)}
    end

    def identify_features(file)
      blocks = Array.new
      accumulator = Array.new
      ic = Iconv.new('UTF-8//TRANSLIT//IGNORE', 'LATIN1')
      while(line = file.gets)
        content = ic.iconv(line + ' ')[0..-2].strip
        if content.size == 0 && !accumulator.empty?
          blocks << accumulator
          accumulator = Array.new
          next
        end
        accumulator << content
      end
      blocks
    end

    def isolate_updates(blocks)
      blocks.select{|block| block.select {|x| x =~ /;FID=/}.size > 0}
    end

    def create_selectable_item(update)
      item = {selection: {}}
      item[:id] = update.select {|x| x =~ /;FID=/}[0].match(/;FID=(\d+)/)[1]
      item[:selection][:name] = update.select {|x| x =~ /^Label=/}[0].match(/^Label=(.+)/)[1]
      coordinates = update.select {|x| x =~ /Data0=/}[0].match(/Data0=\((.+)\)/)[1]
      item[:selection][:longitude] = coordinates.split(",")[1]
      item[:selection][:latitude] = coordinates.split(",")[0]
      item
    end

  end

end