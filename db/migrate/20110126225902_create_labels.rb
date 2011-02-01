class CreateLabels < ActiveRecord::Migration
  def self.up
    create_table :labels do |t|
      t.string :key, :null => false
      t.string :value, :null => false
      t.string :classification
      t.references :location
      t.timestamps
    end

    execute %{
      INSERT INTO labels (key, value, classification, location_id)
      SELECT 'IMPORTED FROM', import_id, 'SYSTEM', id FROM Locations WHERE import_id is not null;
      ALTER TABLE locations DROP COLUMN import_id;
    }

  end

  def self.down
    drop_table :labels
  end
end

