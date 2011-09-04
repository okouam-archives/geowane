class CreateBoundariesTable < ActiveRecord::Migration
  def change
    create_table :boundaries, :force => true do |t|
      t.string :name, :null => false
      t.integer :level, :null => false
      t.string :classification, :null => false
      t.integer :parent_id
    end
    add_column :boundaries, :feature, :geometry, :limit => nil, :srid => 4326
    add_index :boundaries, ["level"], :name => "idx_administrative_units_level"
    add_index :boundaries, ["feature"], :name => "idx_administrative_units_feature", :spatial => true
  end
end
