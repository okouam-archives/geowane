class ShapefilesController < ApplicationController
  resource_controller
  layout "admin"

  new_action.before do
    @shapefile = Shapefile.new
    @shapefile.locations= params[:shapefile][:locations].join(",")
  end

  create.wants.html do
    redirect_to shapefiles_path
  end

  def download
    shapefile = Shapefile.find(params[:id])

    config = ActiveRecord::Base.configurations[Rails.env]
    ENV['PGHOST'] = config["host"] if config["host"]
    ENV['PGPORT'] = config["port"].to_s if config["port"]
    ENV['PGPASSWORD'] = config["password"].to_s if config["password"]
    ENV['PGUSER'] = config["username"].to_s if config["username"]
    database = config['database']

    output = File.join(Rails.root, "tmp", "#{shapefile.filename}.shp")

    command = "/usr/bin/pgsql2shp -f #{output} -d #{database} \"select ST_SetSRID(ST_MakePoint(longitude, latitude), 4326), category_id, commune_id, region_id, city_id, country_id, name, longitude, latitude, email, telephone, fax, website, postal_address, opening_hours, user_rating from locations where id in (#{shapefile.locations})\""
    Rails.logger.info "Using the following command: #{command}"

    f = open("|#{command}")
    Rails.logger.info f.read()

    filename = "#{shapefile.filename}.tar"

    f = open("|cd #{Rails.root}/tmp && tar -c -f #{filename} #{shapefile.filename}.*")
    Rails.logger.info f.read()
    
    send_data File.read(File.join(Rails.root, "tmp", filename)), :filename => filename
  end

end
