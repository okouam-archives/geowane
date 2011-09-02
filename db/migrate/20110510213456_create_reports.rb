class CreateReports < ActiveRecord::Migration
  def up
    execute("CREATE SCHEMA reports AUTHORIZATION deployment")
    files = ["partners", "categories", "cities", "collectors", "boundaries_0"]
    files.each do |file|
      script = File.join(Rails.root, "db/resources/scripts/reports/#{file}.sql")
      execute File.read(script)
    end
  end
end
