class CreateRoutingFunctions < ActiveRecord::Migration
  def up
    execute("CREATE SCHEMA routing AUTHORIZATION deployment")
    files = ["create_connector", "find_route", "get_angles", "find_closest_edge"]
    files.each do |file|
      script = File.join(Rails.root, "db/resources/scripts/functions/routing.#{file}.sql")
      execute File.read(script)
    end
  end
end
