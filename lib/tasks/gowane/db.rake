#rake gowane:db:import[shapefile_name] RAILS_ENV=?

namespace :db do

  task :load_config => :rails_env do
    require 'active_record'
    ActiveRecord::Base.configurations = Rails.configuration.database_configuration
    config = ActiveRecord::Base.configurations[Rails.env || 'development']
    @database = config['database']
    ENV['PGHOST'] = config["host"] if config["host"]
    ENV['PGPORT'] = config["port"].to_s if config["port"]
    ENV['PGPASSWORD'] = config["password"].to_s if config["password"]
  end

  namespace :import do

    desc "Import POI shapefiles into database"
    task :poi, [:response] => [:load_config, :environment] do |t, args|

      `#{File.join(File.dirname(__FILE__), "shp2pgsql")} -s 4326  -d  #{args[:response]} public.poi_external | iconv -f LATIN1 -t UTF-8 | psql -U #{config["username"]} -d #{database}`
      `psql #{database} -U #{config["username"]} -f #{File.join(File.dirname(__FILE__), "shp_to_gowane.sql")}`

      Location.all.where("feature is null AND name is not null").each do |location|
        location.save!
      end
    end

  end

  desc "Kill all sessions to a database"
  task :disconnect =>  [:load_config, :environment] do
    processes = `ps ax|grep '.*[0-9]:[0-9][0-9] postgres:.*'|grep cms_development`
    if processes == ""
      puts "No connections to #{@database} found."
    else
      processes.each_line do |process|
        if process =~ /([0-9]+\s)/
          command = `sudo kill -9 #{$1.chop}`
          puts "Executing command: #{command}"
          `#{command}`
        end
      end
    end
  end

end