class CleanUpForLabels < ActiveRecord::Migration
  def self.up
    execute %{
      INSERT INTO labels (key, value, classification, location_id)
      SELECT 'IMPORTED FROM', import_id, 'SYSTEM', id FROM Locations WHERE import_id is not null;
      ALTER TABLE locations DROP COLUMN import_id;
    }
  end

  def self.down
  end
end
