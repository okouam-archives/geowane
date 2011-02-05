class LoadAdministrativeUnits < ActiveRecord::Migration

  def self.up
    ["BENIN", "BURKINA FASO", "GHANA", "GUINEA", "IVORY COAST", "MALI", "SENEGAL", "TOGO"].each do |directory|
      for i in 0..4 do
        file = File.join(Rails.root, "db/resources/#{directory}/LEVEL_#{i}")
        if File.exists?(file)
          ShpFile.open(file) do |shp|
            shp.each do |shape|
              feature = shape.geometry
              name = shape.data["Name"]
              type = shape.date["Type"]
              AdministrativeUnit.create!(:name => name, :type => type, :level => i, :feature => feature)
            end
          end
        end
      end
    end
  end

  def self.down
  end

end
