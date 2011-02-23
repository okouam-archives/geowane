require 'geocms_tools'

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
        puts "#{Feature.import(folder)} features were imported from the files in '#{folder}'"
      end
    end   
  end

  desc "Load PostGIS functionality into a database"
  task :postgis => [:load_config, :environment] do
    postgis =  GeocmsTools::Postgis.new(ActiveRecord::Base.connection)
    postgis.install_postgis
  end

  desc "Kill all sessions to a database"
  task :disconnect => [:load_config, :environment] do
    GeocmsTools::Postgresql.kill_connections(@database)
  end

  desc "Rebuild a spatial database"
  task :rebuild => [:load_config, :environment] do
    Rake::Task["geocms:disconnect"].reenable
    Rake::Task["geocms:disconnect"].invoke
    Rake::Task["db:drop"].reenable
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].reenable
    Rake::Task["db:create"].invoke
    Rake::Task["geocms:postgis"].reenable
    Rake::Task["geocms:postgis"].invoke
    Rake::Task["db:migrate"].reenable
    Rake::Task["db:migrate"].invoke
  end

end
