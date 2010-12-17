class Export < ActiveRecord::Base
  has_attached_file :output
  attr_protected :output_file_name, :output_content_type, :output_size
  enum_attr :output_format, %w(.MP ^.SHP .GPX)
  belongs_to :user

  def execute(output_filename, locations)

    config = ActiveRecord::Base.configurations[Rails.env]
    ENV['PGHOST'] = config["host"] if config["host"]
    ENV['PGPORT'] = config["port"].to_s if config["port"]
    ENV['PGPASSWORD'] = config["password"].to_s if config["password"]
    ENV['PGUSER'] = config["username"].to_s if config["username"]
    database = config['database']

    output = File.join(Rails.root, "tmp", "#{output_filename}.shp")

    command = "/usr/bin/pgsql2shp -f #{output} -d #{database} \"select ST_SetSRID(ST_MakePoint(longitude, latitude), 4326), category_id, commune_id, region_id, city_id, country_id, name, longitude, latitude, email, telephone, fax, website, postal_address, opening_hours, user_rating from locations where id in (#{locations})\""

    open("|#{command}")

    filename = "#{output_filename}.tar"

    open("|cd #{Rails.root}/tmp && tar -c -f #{filename} #{output_filename}.*")

    File.open(File.join(Rails.root, "tmp", filename), 'rb') do |output_file|
      self.output = output_file
    end

  end

end