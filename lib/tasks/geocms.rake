namespace :geocms do

  task :load_config => :rails_env do
    require 'active_record'
    ActiveRecord::Base.configurations = Rails.configuration.database_configuration
    config = ActiveRecord::Base.configurations[Rails.env || 'development']
    @database = config['database']
    ENV['PGHOST'] = config["host"] if config["host"]
    ENV['PGPORT'] = config["port"].to_s if config["port"]
    ENV['PGPASSWORD'] = config["password"].to_s if config["password"]
  end

  desc "Copies the non-fingerprinted image assets over to the public directory"
  task :assets => :environment  do
    openlayers = Dir.glob(File.join(Rails.root, "app/assets/images/OpenLayers/**"))
    icons = Dir.glob(File.join(Rails.root, "app/assets/images/icons/**"))
    FileUtils.cp_r(openlayers, File.join(Rails.root, "public/assets/OpenLayers"))
    FileUtils.cp_r(icons, File.join(Rails.root, "public/assets/icons"))
  end

  desc "Update geolocatable data for all locations"
  task :geolocation => :environment do
    Rails.logger = Logger.new(STDOUT)
    count = Location.where("road_id IS NULL").count
    counter = 1
    Location.where("road_id IS NULL").each do |location|
      location.update_dynamic_attributes
      location.save!
      puts "#{counter}/#{count} #{location.road_id ? "True" : "False"}"
      counter = counter + 1
    end
  end

  desc "Pulls down the production database into the development database"
  task :pull do
    ActiveRecord::Base.configurations = Rails.configuration.database_configuration
    production_db = ActiveRecord::Base.configurations["production"]['database']
    database = ActiveRecord::Base.configurations[Rails.env]['database']
    system("sudo service postgresql-8.4 restart")
    system("dropdb #{database}")
    system("createdb #{database}")
    system("ssh okouam@xkcd.codeifier.com 'pg_dump #{production_db} -f #{production_db}.backup --clean --format c'")
    system("cd /tmp && scp okouam@xkcd.codeifier.com:/home/okouam/cms_production.backup cms_production.backup")
    system("cd /tmp && pg_restore #{production_db}.backup -d #{database} -v > pg_restore.log 2>&1")
    system("cd /tmp && rm cms_production.backup")
    system("ssh okouam@xkcd.codeifier.com 'rm #{production_db}.backup'")
  end

  namespace :features do

    desc "Import features required for rendering the 0-One digital map from shapefiles"
    task :import => [:environment] do
      folders = ["/home/okouam/Dropbox/0-One/Operations/Technical/Mapping/Shapefiles/Benin",
        "/home/okouam/Dropbox/0-One/Operations/Technical/Mapping/Shapefiles/Cote d'Ivoire",
        "/home/okouam/Dropbox/0-One/Operations/Technical/Mapping/Shapefiles/Togo",
        "/home/okouam/Dropbox/0-One/Operations/Technical/Mapping/Shapefiles/Senegal"]
      ActiveRecord::Base.connection.execute("TRUNCATE features")
      folders.each do |folder|
        puts "#{Loader.import(folder)} features were imported from the files in '#{folder}'"
      end
    end   

  end

  namespace :db do

    desc "Rebuild test database"
    task :rspec => [:environment] do
      system("rake db:drop RAILS_ENV=test")
      system("rake db:create RAILS_ENV=test")
      system("rake db:migrate RAILS_ENV=test")
    end

  end

end
