class CreateReports < ActiveRecord::Migration
  def self.up
    files = ["category_workflow_partner", "category_workflow", "city_workflow", "collector_workflow"]
    files.each do |file|
      script = File.join(Rails.Root, "db/resources/scripts/views/#{file}_report.sql")
      execute File.read(script)
    end
  end

  def self.down
  end
end
