class CreateAdministrativeUnits < ActiveRecord::Migration
  def self.up
    create_table :administrative_units, :force => true do |t|
      t.string :name, :null => false
      t.integer :level, :null => false
      t.string :classification, :null => false
    end
    add_column :administrative_units, :feature, :geometry, :limit => nil, :srid => 4326
    add_index :administrative_units, ["level"], :name => "idx_administrative_units_level"
    add_index :administrative_units, ["feature"], :name => "idx_administrative_units_feature", :spatial => true

    connection.execute %{
      CREATE OR REPLACE VIEW categorization_chart as
      SELECT
            name as row_name, category, count(*) as value
          FROM
            (SELECT l.id, au.name, case when count(location_id) > 0 then 'tagged' else 'untagged' end category
            FROM locations l LEFT JOIN tags t ON t.location_id = l.id AND t.category_id is not null
            LEFT JOIN administrative_units au ON l.level_0 = au.id GROUP BY l.id, au.name, location_id) base
          GROUP BY 1, 2 ORDER BY 1, 2;
    }

    connection.execute %{
      CREATE OR REPLACE VIEW workflow_chart AS
      select au.name as row_name, status as category, count(*) as value from locations l
      LEFT JOIN administrative_units au ON l.level_0 = au.id
      GROUP by 1, 2 ORDER BY 1, 2;
    }

    connection.execute %{
      CREATE OR REPLACE VIEW collector_chart as
        SELECT u.login as row_name, l.status as category, count(*) as value
        FROM locations l JOIN users u ON l.user_id = u.id
        GROUP BY 1,2 ORDER BY 1, 2;
    }


  end

  def self.down
    drop_table :administrative_units
  end

end
