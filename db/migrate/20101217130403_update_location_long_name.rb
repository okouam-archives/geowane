class UpdateLocationLongName < ActiveRecord::Migration
  def self.up
    execute %{
      UPDATE locations SET long_name = name WHERE long_name IS NULL
    }
  end

  def self.down
  end
end
