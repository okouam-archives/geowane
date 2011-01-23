  module Importers

    class MP

      def preview(file)

        commands = parse(file)

        locations = Location.find(commands.map {|command| command[:id]})

        lookup = {}
        locations.each do |loc|
          lookup[loc.id] = loc
        end

        changes = {}

        commands.each do |command|
          id = command[:id]
          change = {:before => {:id => id}, :after => command}
          if location = lookup[id.to_i]
            change[:before][:name] = location.name
            change[:before][:longitude] = location.longitude
            change[:before][:latitude] = location.latitude
          end
          changes[id] = change if change[:before].diff(change[:after])
        end

        changes

      end

      def update(file, selection)

        commands = parse(file)
        counter = 0

        commands.each do |command|
          next unless selection.include?(command[:id])
          begin
            location = Location.find(command[:id])
            location.longitude = command[:longitude]
            location.latitude = command[:latitude]
            location.name = command[:name]
            location.comments.build(:title => "Updated from .MP", :comment => "Updated from .MP")
            location.save!
            counter = counter + 1
          rescue ActiveRecord::RecordNotFound
          end
        end

        counter

      end

      def parse(file)

        temp_file = File.open(file)
        blocks = []
        accumulator = []
        ic = Iconv.new('UTF-8//TRANSLIT//IGNORE', 'LATIN1')

        while(line = temp_file.gets)
          content = ic.iconv(line + ' ')[0..-2].strip
          if content.size == 0 && accumulator != []
            blocks << accumulator
            accumulator = []
            next
          end
          accumulator << content
        end

        updates = blocks.select{|block| block.select {|x| x =~ /;FID=/}.size > 0}

        updates.map {|update| create_command(update)}

      end

      def create_command(update)
        command = {}
        command[:id] = update.select {|x| x =~ /;FID=/}[0].match(/;FID=(\d+)/)[1]
        command[:coordinates] = update.select {|x| x =~ /Data0=/}[0].match(/Data0=\((.+)\)/)[1]
        command[:name] = update.select {|x| x =~ /^Label=/}[0].match(/^Label=(.+)/)[1]
        command[:longitude] = command[:coordinates].split(",")[1]
        command[:latitude] = command[:coordinates].split(",")[0]
        command
      end

    end

  end