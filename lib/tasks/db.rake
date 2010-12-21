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

  task :shapefile => [:load_config, :environment]  do
       
  
  end

  task :refresh_statistics => [:environment] do
    ["countries", "regions", "cities", "communes"].each do |level|
      ActiveRecord::Base.connection.execute %{
      UPDATE #{level} SET 
	      new_locations = "new", 
	      invalid_locations = invalid,
	      corrected_locations = corrected, 
	      field_checked_locations = field_checked, 
	      audited_locations = audited,
	      total_locations = locations_count
      FROM
          (SELECT #{level}.id,
              SUM(CASE WHEN status = 'new' THEN 1 ELSE 0 END) as "new",
              SUM(CASE WHEN status = 'invalid' THEN 1 ELSE 0 END) as invalid,
              SUM(CASE WHEN status = 'corrected' THEN 1 ELSE 0 END) as corrected,
              SUM(CASE WHEN status = 'audited' THEN 1 ELSE 0 END) as audited,
              SUM(CASE WHEN status = 'field_checked' THEN 1 ELSE 0 END) as field_checked,
              count(*) as locations_count
            FROM topologies 
            JOIN #{level} ON #{level}.id = topologies.#{level.singularize}_id
            JOIN locations ON locations.id = topologies.location_id
            GROUP BY #{level}.id) as statistics
      WHERE 
        statistics.id = #{level}.id;
      UPDATE #{level} SET uncategorized_locations = uncategorized 
      FROM (SELECT #{level.singularize}_id, count(*) as uncategorized
            FROM topologies 
            JOIN locations ON locations.id = topologies.location_id
            WHERE tags_count < 1
            GROUP BY #{level.singularize}_id) as statistics
            where statistics.#{level.singularize}_id = #{level}.id;
      };
    end

  end

  task :postgis do

    ActiveRecord::Base.configurations = Rails.configuration.database_configuration
    database = ActiveRecord::Base.configurations[Rails.env]['database']
    `createlang plpgsql #{database}`

    postgis_sql_candidates = `locate postgis.sql`
    unless postgis_sql_candidates && !postgis_sql_candidates.blank?
      raise "The postgis.sql script cannot be found."
    end

    spatial_ref_sys_sql_candidates = `locate spatial_ref_sys.sql`
    unless spatial_ref_sys_sql_candidates && !spatial_ref_sys_sql_candidates.blank?
      raise "The spatial_ref_sys.sql script cannot be found."
    end

    postgis_sql = postgis_sql_candidates.split("\n")[0]
    spatial_ref_sys_sql = spatial_ref_sys_sql_candidates.split("\n")[0]

    `psql -d #{database} -f #{postgis_sql}`
    `psql -d #{database} -f #{spatial_ref_sys_sql}`

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
