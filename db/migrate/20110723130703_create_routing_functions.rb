class CreateRoutingFunctions < ActiveRecord::Migration
  def self.up
    files = ["create_connector", "find_route", "get_angles", "find_closest_edge"]
    files.each do |file|
      script = File.join(Rails.Root, "db/resources/scripts/functions/geocms_#{file}.sql")
      execute File.read(script)
    end
  end

  def self.down
  end
end
