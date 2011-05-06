class CreateBoundariesTable < ActiveRecord::Migration

  def self.up
    unless table_exists?(:boundaries)
      create_table :boundaries, :force => true do |t|
        t.string :name, :null => false
        t.integer :level, :null => false
        t.string :classification, :null => false
      end
      add_column :boundaries, :feature, :geometry, :limit => nil, :srid => 4326
      add_index :boundaries, ["level"], :name => "idx_administrative_units_level"
      add_index :boundaries, ["feature"], :name => "idx_administrative_units_feature", :spatial => true

      connection.execute %{
        CREATE OR REPLACE VIEW categorization_chart as
        SELECT
            name as row_name, category, count(*) as value
          FROM
            (SELECT l.id, au.name, case when count(location_id) > 0 then 'tagged' else 'untagged' end category
            FROM locations l LEFT JOIN tags t ON t.location_id = l.id AND t.category_id is not null
            LEFT JOIN boundaries ON l.level_0 = au.id GROUP BY l.id, au.name, location_id) base
          GROUP BY 1, 2 ORDER BY 1, 2;
      }

      connection.execute %{
        CREATE OR REPLACE VIEW workflow_chart AS
        select au.name as row_name, status as category, count(*) as value from locations l
        LEFT JOIN boundaries au ON l.level_0 = au.id
        GROUP by 1, 2 ORDER BY 1, 2;
      }

      connection.execute %{
        CREATE OR REPLACE VIEW collector_chart as
        SELECT u.login as row_name, l.status as category, count(*) as value
        FROM locations l JOIN users u ON l.user_id = u.id
        GROUP BY 1,2 ORDER BY 1, 2;
      }
    end
  end

  def self.down
    drop_table :boundaries if table_exists?(:boundaries)
  end

end
