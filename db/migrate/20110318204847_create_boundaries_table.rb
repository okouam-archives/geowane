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
    end
  end

  def self.down
    drop_table :boundaries if table_exists?(:boundaries)
  end

end
