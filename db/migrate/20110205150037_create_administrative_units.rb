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
  end

  def self.down
    drop_table :administrative_units
  end

end
